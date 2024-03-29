package com.teamapt.monnify_flutter_sdk_plus

import android.app.Activity.RESULT_OK
import android.content.Intent
import com.teamapt.monnify.sdk.Monnify
import com.teamapt.monnify.sdk.MonnifyTransactionResponse
import com.teamapt.monnify.sdk.data.model.TransactionDetails
import com.teamapt.monnify.sdk.model.PaymentMethod
import com.teamapt.monnify.sdk.rest.data.request.SubAccountDetails
import com.teamapt.monnify.sdk.service.ApplicationMode
import com.teamapt.monnify.sdk.Status
import com.teamapt.monnify.sdk.data.model.TransactionType
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import java.math.BigDecimal


const val MONNIFY_SDK_PAYMENT_REQUEST_CODE = 982
const val MONNIFY_SDK_PAYMENT_RESULT_KEY = "monnify_sdk_result_key"

const val ERROR_CODE_SDK_INITIALIZATION = "INIT_ERROR"
const val ERROR_CODE_PAYMENT_INITIALIZATION = "INIT_PAYMENT_ERROR"
class MethodCallHandlerImpl(
    messenger: BinaryMessenger?,
    private val binding: ActivityPluginBinding
) :
    MethodChannel.MethodCallHandler, PluginRegistry.ActivityResultListener {

    private var channel: MethodChannel? = null
    private var result: MethodChannel.Result? = null
    private val monnify = Monnify.instance


    init {
        channel = MethodChannel(messenger!!, "monnify_flutter_sdk_plus")

        channel?.setMethodCallHandler(this)

        binding.addActivityResultListener(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        this.result = result

        when (call.method) {

            "initialize" -> {
                initialiseMonnify(call)
            }

            "initializePayment" -> {
                makePayment(call)
            }


            else -> result.notImplemented()
        }

    }

    /**
     * @initializeMonnify initializes monnify
     * @param arg is a map sent from the client side
     */
    private fun initialiseMonnify(call: MethodCall) {

        if (call.arguments == null || !(call.arguments is Map<*,*>)) {
            result?.error(ERROR_CODE_SDK_INITIALIZATION, "Invalid input(s)", null)
            return
        }

        val monnify = Monnify.instance

        call.argument<String>("apiKey").let {
            if (it != null) {
                monnify.setApiKey(it)
            }
        }
        call.argument<String>("contractCode")?.let {
            monnify.setContractCode(it)
        }
        when (call.argument<String?>("applicationMode")) {
            "TEST" -> monnify.setApplicationMode(ApplicationMode.TEST)
            "LIVE" -> monnify.setApplicationMode(ApplicationMode.LIVE)
        }

        result?.success(true)

    }

    /**
     * It is invoked when making transaction
     * @param arg is the data that was passed in from the flutter side to make payment
     */
    private fun makePayment(call: MethodCall) {

        if (call.arguments == null || !(call.arguments is Map<*,*>)) {
            result?.error(ERROR_CODE_PAYMENT_INITIALIZATION, "Invalid input(s)", null)
            return
        }

        val monnify = Monnify.instance

        // Verify that initialization has occurred
        if (monnify.getApiKey().isEmpty() || monnify.getContractCode().isEmpty()) {
            result?.error(ERROR_CODE_PAYMENT_INITIALIZATION, "Monnify has not yet been initialized!", null)
        }

        val transaction = TransactionDetails.Builder().apply {
            call.argument<Double?>("amount")?.let {
                this.amount(BigDecimal.valueOf(it))
            }
            call.argument<String?>("currencyCode")?.let {
                this.currencyCode(it)
            }
            call.argument<String?>("customerName")?.let {
                this.customerName(it)
            }
            call.argument<String?>("customerEmail")?.let {
                this.customerEmail(it)
            }
            call.argument<String?>("paymentReference")?.let {
                this.paymentReference(it)
            }
            call.argument<String?>("paymentDescription")?.let {
                this.paymentDescription(it)
            }
            call.argument<HashMap<String, String>?>("metaData")?.let {
                this.metaData(it)
            }
            extractPaymentMethods(call)?.let {
                this.paymentMethods(it)
            }
            extractIncomeSplitConfig(call)?.let {
                this.incomeSplitConfig(it)
            }

        }.build()

        monnify.initializePayment(
            binding.activity,
            transaction,
            MONNIFY_SDK_PAYMENT_REQUEST_CODE,
            MONNIFY_SDK_PAYMENT_RESULT_KEY)
    }

    /**
     * this is the call back that is invoked when the activity result returns a value after calling
     * startActivityForResult().
     * @param data is the intent that has the bundle where we can get our result [MonnifyTransactionResponse]
     * @param requestCode if it matches with our [REQUEST_CODE] it means the result if the one we
     * asked for.
     * @param resultCode, it is okay if it equals [RESULT_OK]
     */
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {

        if (requestCode != MONNIFY_SDK_PAYMENT_REQUEST_CODE)
            return false

        val monnifyTransactionResponse =
            data?.getParcelableExtra<MonnifyTransactionResponse>(MONNIFY_SDK_PAYMENT_RESULT_KEY) as MonnifyTransactionResponse

        val map: MutableMap<String, Any> = mutableMapOf()

        var paymentMethod = ""
        val responsePaymentMethod = monnifyTransactionResponse.paymentMethod
        if (responsePaymentMethod != null) {
            paymentMethod = responsePaymentMethod.name
        }

        map.put(KEY_TRANSACTION_REFERENCE, monnifyTransactionResponse.transactionReference)
        map.put(KEY_TRANSACTION_STATUS, monnifyTransactionResponse.status.name)
        map.put(KEY_PAYMENT_METHOD, paymentMethod)
        map.put(KEY_AMOUNT_PAID, monnifyTransactionResponse.amountPaid.toDouble())
        map.put(KEY_AMOUNT_PAYABLE, monnifyTransactionResponse.amountPayable.toDouble())
        map.put(KEY_PAYMENT_DATE, monnifyTransactionResponse.paidOn ?: "")
        map.put(KEY_PAYMENT_REFERENCE, monnifyTransactionResponse.paymentReference)

        result?.success(map)

        return true
    }


    /**
     * dispose the channel when this handler detaches from the activity
     */
    fun dispose() {
        channel?.setMethodCallHandler(null)
        channel = null
    }

    private fun extractPaymentMethods(call: MethodCall): List<PaymentMethod>? {

        val paymentMethods = call.argument<List<String>>("paymentMethods")

        return paymentMethods?.map {
            PaymentMethod.valueOf(it)
        }
    }

    private fun extractIncomeSplitConfig(call: MethodCall): List<SubAccountDetails>? {

        val incomeSplitConfig = call.argument<List<Map<*,*>>>("incomeSplitConfig")

        return incomeSplitConfig?.map {
            SubAccountDetails(
                it["subAccountCode"] as String? ?: "",
                (it["feePercentage"] as Double??: 0.0).toFloat(),
                BigDecimal.valueOf(it["splitAmount"] as Double??: 0.0) ,
                it["feeBearer"] as Boolean ??: false
            )
        }
    }

    companion object {
        private const val KEY_TRANSACTION_REFERENCE = "transactionReference"
        private const val KEY_TRANSACTION_STATUS = "transactionStatus"
        private const val KEY_PAYMENT_METHOD = "paymentMethod"
        private const val KEY_AMOUNT_PAID = "amountPaid"
        private const val KEY_PAYMENT_DATE = "paymentDate"
        private const val KEY_AMOUNT_PAYABLE = "amountPayable"
        private const val KEY_PAYMENT_REFERENCE = "paymentReference"
    }
}




