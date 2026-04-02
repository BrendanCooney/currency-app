package com.brendan.currencyapp.data.local

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase

@Database(
    entities = [ExchangeRateEntity::class, ConversionHistoryEntity::class],
    version = 1,
    exportSchema = false
)
abstract class CurrencyAppDatabase : RoomDatabase() {
    abstract fun exchangeRateDao(): ExchangeRateDao
    abstract fun conversionHistoryDao(): ConversionHistoryDao

    companion object {
        @Volatile
        private var Instance: CurrencyAppDatabase? = null

        fun getDatabase(context: Context): CurrencyAppDatabase {
            return Instance ?: synchronized(this) {
                Room.databaseBuilder(
                    context.applicationContext,
                    CurrencyAppDatabase::class.java,
                    "currency_database"
                ).build().also { Instance = it }
            }
        }
    }
}
