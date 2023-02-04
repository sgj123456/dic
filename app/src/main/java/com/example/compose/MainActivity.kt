package com.example.compose

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.*
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.foundation.shape.CutCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.TextUnit
import androidx.compose.ui.unit.TextUnitType
import com.example.compose.ui.theme.ComposeTheme
import com.google.gson.Gson
import kotlinx.coroutines.*

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        val dictionary = Gson().fromJson(
            resources.openRawResource(R.raw.dictionary).reader().readText(), Array<Array<String>>::class.java
        )
        super.onCreate(savedInstanceState)
        setContent {
            val results: MutableState<Array<Array<String>>> = remember { mutableStateOf(arrayOf()) }
            val textValue = remember { mutableStateOf("") }
            val hash: LinkedHashMap<String, Array<Array<String>>> = remember { linkedMapOf() }
            val word: MutableState<Array<String>> = remember { mutableStateOf(arrayOf()) }
            val switch = remember { mutableStateOf(false) }
            ComposeTheme {
                // A surface container using the 'background' color from the theme
                Surface(modifier = Modifier.fillMaxSize(), color = MaterialTheme.colorScheme.background) {
                    Column(modifier = Modifier.fillMaxSize()) {
                        MyCard()
                        MyOutlinedTextField(textValue)
                        MyButthon(dictionary, results, textValue, hash)
                        LazyVerticalGridSample(results.value, word, switch)
                        AlertDialog(word, switch)
                    }
                }
            }
        }
    }
}

@Composable
fun MyCard(
) {
    Card(
        modifier = Modifier.background(color = Color.LightGray).padding(Dp(5F)).clip(
            CutCornerShape(Dp(10F))
        ),
    ) {
        Text(
            text = "万词王",
            fontStyle = FontStyle(0),
            fontSize = TextUnit(10F, TextUnitType.Em),
            textAlign = TextAlign.Center,
            modifier = Modifier.fillMaxWidth()
        )
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MyOutlinedTextField(textValue: MutableState<String>) {
    OutlinedTextField(value = textValue.value, modifier = Modifier.fillMaxWidth(), onValueChange = { input ->
        textValue.value = input
    })
}

@Composable
fun MyButthon(
    dictionary: Array<Array<String>>,
    results: MutableState<Array<Array<String>>>,
    textValue: MutableState<String>,
    hash: LinkedHashMap<String, Array<Array<String>>>
) {
    val find = {
        results.value = hash[textValue.value] ?: hash.filterKeys {
            textValue.value.startsWith(it)
        }.maxByOrNull { it.key.length }?.value?.filter { v ->
            textValue.value.toRegex().containsMatchIn(v[0])
        }?.toTypedArray() ?: dictionary.filter { v -> textValue.value.toRegex().containsMatchIn(v[0]) }.toTypedArray()
            .also {
                hash[textValue.value] = it
            }
        if (hash.size >= 10) hash.remove(hash.keys.first())
    }
    Button(
        modifier = Modifier.fillMaxWidth(),
        onClick = find,
    ) {
        Text(text = "查找")
    }
}

@Composable
fun LazyVerticalGridSample(
    data: Array<Array<String>>, word: MutableState<Array<String>>, switch: MutableState<Boolean>
) {
    LazyVerticalGrid(
        columns = GridCells.Fixed(3),
        horizontalArrangement = Arrangement.spacedBy(Dp(5F)),
        verticalArrangement = Arrangement.spacedBy(Dp(5F)),
        modifier = Modifier.padding(Dp(5F))
    ) {
        items(data.toList()) { item ->
            Button(modifier = Modifier.border(BorderStroke(Dp(1.25F), MaterialTheme.colorScheme.primary)),
                contentPadding = PaddingValues(Dp(0F)),
                shape = CutCornerShape(Dp(5F)),
                onClick = {
                    word.value = item
                    switch.value = true
                }) {
                Text(text = item.toList()[0], overflow = TextOverflow.Clip, modifier = Modifier)
            }
        }
    }
}

@Composable
fun AlertDialog(data: MutableState<Array<String>>, switch: MutableState<Boolean>) {
    if (switch.value) {
        AlertDialog(onDismissRequest = { switch.value = false },
            title = { Text(text = data.value[0]) },
            text = { Text(text = data.value.slice(1 until data.value.size).joinToString()) },
            confirmButton = {
                Text(text = "关闭", modifier = Modifier.clickable(onClick = {
                    switch.value = false
                }))
            },
            containerColor = MaterialTheme.colorScheme.secondaryContainer,
            shape = CutCornerShape(Dp(20F))
        )
    }
}


@Preview(showBackground = true)
@Composable
fun DefaultPreview() {
    ComposeTheme {
//        Greeting(arrayOf(arrayOf()))
    }
}