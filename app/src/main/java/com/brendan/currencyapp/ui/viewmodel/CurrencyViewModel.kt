package com.brendan.currencyapp.ui.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.brendan.currencyapp.data.repository.ExchangeRateRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

data class CurrencyUIState(
    val isLoading: Boolean = false,
    val error: String? = null,
    val rates: Map<String, Double> = emptyMap(),
    val selectedBaseCurrency: String = "USD",
    val conversionResult: Double? = null,
    val lastUpdated: Long = 0L
)

@HiltViewModel
class CurrencyViewModel @Inject constructor(
    private val repository: ExchangeRateRepository
) : ViewModel() {
    private val _uiState = MutableStateFlow(CurrencyUIState())
    val uiState: StateFlow<CurrencyUIState> = _uiState.asStateFlow()

    private val supportedCurrencies = listOf("USD", "GBP", "EUR", "ZAR", "BTC")

    init {
        loadExchangeRates("USD")
    }

    fun loadExchangeRates(baseCurrency: String, forceRefresh: Boolean = false) {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(
                isLoading = true,
                error = null,
                selectedBaseCurrency = baseCurrency
            )

            val result = repository.getExchangeRates(baseCurrency, forceRefresh)

            if (result.isSuccess) {
                val rates = result.getOrNull() ?: emptyMap()
                val filteredRates = rates.filterKeys { it in supportedCurrencies }
                
                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    rates = filteredRates,
                    lastUpdated = System.currentTimeMillis()
                )
            } else {
                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    error = result.exceptionOrNull()?.message ?: "Failed to load rates"
                )
            }
        }
    }

    fun convertCurrency(fromCurrency: String, toCurrency: String, amount: Double) {
        if (amount <= 0) {
            _uiState.value = _uiState.value.copy(conversionResult = null)
            return
        }

        viewModelScope.launch {
            val result = repository.convertCurrency(fromCurrency, toCurrency, amount)

            if (result.isSuccess) {
                _uiState.value = _uiState.value.copy(
                    conversionResult = result.getOrNull(),
                    error = null
                )
            } else {
                _uiState.value = _uiState.value.copy(
                    error = result.exceptionOrNull()?.message ?: "Conversion failed"
                )
            }
        }
    }

    fun getSupportedCurrencies(): List<String> = supportedCurrencies
}
