String gerarChatId(String a, String b) {
  return a.compareTo(b) <= 0 ? "${a}_$b" : "${b}_$a";
}