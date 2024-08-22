# Assembly Language Playfair Cipher
姓名：李名智  
學號：1102924  
## 介紹
   由組合語言來實作Playfair Cipher，而Playfair Cipher是一種對稱式密碼，一種雙字母取代的加密方法。
### 作法：
- 設計一個5×5的矩陣，矩陣內填入A-Z（I/J視為同一字）
- 將輸入文字做兩兩一組。若組內相同字母，將"X"插入兩字字母之間，並重新分組（例如  HELLO 將分成 HE LX LO）。若最後剩一個字母，也加入"X"。
- 每組中，依Playfair Key Matrix做相對應的操作（分為三種情況）：
  - 情況一：若兩字不同行、不同列，則在矩陣中找出另外兩個字母，使四個字母呈長方形。
  - 情況二：若兩字同橫行，則取字母的右邊一位，若最後邊字母則取最左邊的字母。
  - 情況三：若兩字同直列，則取字母的下方一位，若最下方字母則取最上方的字母。
- 找到新兩字母為原字母的加密結果。
### 設計：Playfair Key Matrix
![image](https://github.com/user-attachments/assets/7257e03f-b9ba-4223-9e7b-8e30753826a2)
## 程式說明（[詳細說明](https://github.com/MingChih123/AssemblyLanguage_PlayfairCipher/blob/main/Playfair%20Cipher%E7%A8%8B%E5%BC%8F%E8%AA%AA%E6%98%8E.pdf)）
主要分為三部分：  
（1）DATA
- 儲存變數
（2）主程式
- 呼叫以下副程式
（3）副程式
- InputTheString：用來輸入文字
- lowertoCap：將輸入的文字轉成大寫並將所有J/j都轉成I
- Twotwo：將處理好的文字用成兩兩一組的array
- Find1：找到第一個字對應Key的位置，得知row1、col1
- Find2：找到第二個字對應Key的位置，得知row2、col2
- CmpRow：比較兩字的Row
- CmpCol：比較兩字的Col
- Other：不同行不同列
- InputPF：將處理好字輸到密文中

## 成果圖
![image](https://github.com/user-attachments/assets/c63e2c48-3e1b-4b50-acba-592cce923dbc)
