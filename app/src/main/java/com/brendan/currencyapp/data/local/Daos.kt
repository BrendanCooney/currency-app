package com.brendan.currencyapp.data.local

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query

@Dao
interface ExchangeRateDao {
    @Query("SELECT * FROM exchange_rates WHERE baseCode = :baseCode")
    suspend fun getExchangeRate(baseCode: String): ExchangeRateEntity?

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertExchangeRate(rate: ExchangeRateEntity)

    @Query("DELETE FROM exchange_rates")
    suspend fun clearAll()
}

@Dao
interface ConversionHistoryDao {
    @Query("SELECT * FROM conversion_history ORDER BY timestamp DESC LIMIT 50")
    suspend fun getRecentConversions(): List<ConversionHistoryEntity>

    @Insert
    suspend fun insertConversion(conversion: ConversionHistoryEntity)

    @Query("DELETE FROM conversion_history")
    suspend fun clearAll()
}
