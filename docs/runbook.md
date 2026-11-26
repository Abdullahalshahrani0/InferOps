# InferOps Runbook — Model Server

Service: `inferops-model` · Port: `127.0.0.1:11434` · Logs: `journalctl -u inferops-model`

## First check (always)
~~~bash
systemctl is-active inferops-model
curl -s http://127.0.0.1:11434/api/tags | jq -r '.models[].name'
~~~
- No answer at all → problem is the **service or network** (go to 1).
- Answer with an error → problem is the **request or config** (go to 2).

## 1. Connection refused
Symptom: `curl: (7) Failed to connect ... Couldn't connect to server` (exit code 7)
Cause: service stopped, crashed in a loop, or listening on another port.
Fix:
~~~bash
systemctl status inferops-model --no-pager
journalctl -u inferops-model -n 50 --no-pager
sudo ss -tlnp | grep 11434
sudo systemctl restart inferops-model
~~~

## 2. Model not found
Symptom: `{"error":"model '<name>' not found"}`
Cause: wrong model name, or the model was never pulled.
Fix:
~~~bash
ollama list
ollama pull qwen2.5:0.5b
~~~

## 3. Process killed (crash, OOM, kill -9)
Symptom: short gap in service, new PID in `systemctl status`.
Expected: systemd restarts it within ~3 seconds (`Restart=always`).
Check:
~~~bash
journalctl -u inferops-model --since "10 min ago" --no-pager
free -h
~~~
If it keeps restarting: check memory with `free -h` — the model may be too big for RAM.
