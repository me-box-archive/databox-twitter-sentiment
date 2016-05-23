require! { express, 'body-parser', request, sentiment }

const arbiter-hostname = if process.env.DEBUG? then \localhost else \arbiter

app = express!

app.enable 'trust proxy'

app.use express.static 'static'

app.use body-parser.urlencoded extended: false

app.use (req, res, next) !->
  res.header 'Access-Control-Allow-Origin' \*
  next!

app.get \/status (req, res) !->
  res.send \active

token = null
app.get \/token (req, res) !->
  token := req.query.token
  res.end!

app.get \/sentiment (req, res) !->
  err, response, body <-! request.post url: "http://#arbiter-hostname:7999/databox-twitter-driver/api/statuses/home_timeline.json" form: { token }
  body
    |> JSON.parse
    |> (.map (.text))
    |> (.join ' ')
    |> sentiment
    |> res.send

app.listen (process.env.PORT or 8080)
