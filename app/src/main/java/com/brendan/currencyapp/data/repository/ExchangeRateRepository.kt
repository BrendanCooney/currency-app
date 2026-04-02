package com.brendan.currencyapp.data.repository

import com.brendan.currencyapp.data.local.ExchangeRateEntity
import com.brendan.currencyapp.data.local.CurrencyAppDatabase
import com.brendan.currencyapp.data.remote.ExchangeRateApi
import com.google.gson.Gson
import javax.inject.Inject

class ExchangeRateRepository @Inject constructor(
    private val api: ExchangeRateApi,
    private val database: CurrencyAppDatabase,
    private val gson: Gson
) {
    private val exchangeRateDao = database.exchangeRateDao()

    suspend fun getExchangeRates(baseCode: String, forceRefresh: Boolean = false): Result<Map<String, Double>> {
        return try {
            // Try to get from cache first if not forced refresh
            if (!forceRefresh) {
                val cached = exchangeRateDao.getExchangeRate(baseCode)
                val now = System.currentTimeMillis()
                // Use cache if less than 1 hour old
                if (cached != null && (now - cached.timestamp) < 60 * 60 * 1000) {
                    val rates = gson.fromJson(cached.conversionRates, Map::class.java) as Map<String, Double>
                    return Result.success(rates)
                }
            }

            // Fetch from API
            val response = api.getExchangeRates(baseCode)
            
            // Cache the result
            val entity = ExchangeRateEntity(
                baseCode = response.baseCode,
                rates = gson.toJson(response.conversionRates),
                timestamp = System.currentTimeMillis(),
                conversionRates = gson.toJson(response.conversionRates)
            )
            exchangeRateDao.insertExchangeRate(entity)

            Result.success(response.conversionRates)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    suspend fun convertCurrency(
        fromCurrency: String,
        toCurrency: String,
        amount: Double
    ): Result<Double> {
        return try {
            val rates = getExchangeRates(fromCurrency)
            if (rates.isFailure) {
                return Result.failure(rates.exceptionOrNull() ?: Exception("Failed to fetch rates"))
            }

            val ratesMap = rates.getOrNull() ?: emptyMap()
            val rate = ratesMap[toCurrency] ?: return Result.failure(Exception("Currency not found"))

            Result.success(amount * rate)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}
