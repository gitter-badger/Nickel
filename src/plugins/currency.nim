include base
import httpclient, encodings, math

const Url = "http://api.fixer.io/latest?base="

proc getData(): Future[string] {.async.} =
  let client = newAsyncHttpClient()
  var info = ""
  for curr in ["USD", "EUR", "GBP"]:
    let rawData = await client.getContent(Url & curr)
    let data = parseJson(rawData)["rates"]
    # Округляем float до 2 знаков после запятой
    let rubleInfo = $round(data["RUB"].getFNum(), 2)
    
    case curr:
      of "USD":
        info.add("Доллар: ")

      of "EUR":
        info.add("Евро: ")

      of "GBP":
        info.add("Английский фунт: ")

    info.add(rubleInfo & " руб.\n")
  return info

proc call*(api: VkApi, msg: Message) {.async.}=
  await api.answer(msg,  await getData())
