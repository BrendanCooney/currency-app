package com.brendan.currencyapp.data.remote

import retrofit2.http.GET
import retrofit2.http.Path

interface ExchangeRateApi {
    @GET("v6/YOUR_API_KEY/latest/{baseCode}")
    suspend fun getExchangeRates(
        @Path("baseCode") baseCode: String
    ): ExchangeRateResponse

    companion object {
        const val BASE_URL = "https://v6.exchangerate-api.com/"
    }
}
