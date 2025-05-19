package main

import (
	"flag"
	"fmt"
	"github.com/google/uuid"
	"github.com/gorilla/mux"
	"github.com/gorilla/websocket"
	"net/http"
	"strings"
	"sync"
	"time"
)

type Session struct {
	ID    string
	Conn  *websocket.Conn
	Topic string
}

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		return true // 允许所有来源的请求
	},
}

var sessions = make(map[string]*Session) // 存储所有的 session
var mu sync.Mutex

func handleConnection(w http.ResponseWriter, r *http.Request) {
	// 从 URL 中获取 topic 参数
	query := r.URL.Query()
	topic := query.Get("topic")

	// 创建新的 WebSocket 连接
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		// fmt.Println("Error while upgrading connection:", err)
		return
	}
	defer conn.Close()

	// 创建新的 session
	sessionID := uuid.New().String() // 生成唯一 ID
	session := &Session{ID: sessionID, Conn: conn, Topic: topic}

	// 将 session 存储到 sessions 中
	mu.Lock()
	sessions[sessionID] = session
	mu.Unlock()

	fmt.Printf("Client connected with ID: %s, Topic: %s\n", sessionID, topic)

	for {
		// 读取消息
		messageType, msg, err := conn.ReadMessage()
		if err != nil {
			fmt.Println("Error while reading message:", err)
			break
		}
		if strings.Contains(topic, "test") {
			str := string(msg)
			str = strings.ReplaceAll(str, "\r\n", "")
			str = strings.ReplaceAll(str, "\n", "")
			str = strings.ReplaceAll(str, "\r", "")
			fmt.Printf("Received from %s: %s\n", sessionID, str)
		}

		// 广播消息给所有订阅同一 topic 的连接
		if string(msg) == "ping" || len(msg) == 0 {
			continue
		}
		broadcastMessage(session, messageType, msg)
	}
}

// 广播消息给所有订阅同一 topic 的连接
func broadcastMessage(sender *Session, messageType int, msg []byte) {
	mu.Lock()
	defer mu.Unlock()
	for _, session := range sessions {
		if session.ID != sender.ID && session.Topic == sender.Topic && session.Conn != nil {
			err := session.Conn.WriteMessage(messageType, msg)
			// 如果消息字符串中包含test
			if strings.Contains(session.Topic, "test") {
				str := string(msg)
				str = strings.ReplaceAll(str, "\r\n", "")
				str = strings.ReplaceAll(str, "\n", "")
				str = strings.ReplaceAll(str, "\r", "")
				fmt.Printf("Broadcasting message. sender: %s, to: %s, topic: %s, msg: %s, timestamp: %s\n", sender.ID, session.ID, sender.Topic, str, time.Now().String())
			}

			if err != nil {
				session.Conn.Close()
				delete(sessions, session.ID) // 移除已关闭的连接
			}
		}
	}
}
func main() {
	// 解析命令行参数
	port := flag.Int("p", 2000, "Port to run Wayang WebSocket server on")
	help := flag.Bool("h", false, "Show help")
	version := flag.Bool("v", false, "Show version")
	// flag.Usage = func() {
	// 	fmt.Println("Usage: wayang-server [options]")
	// 	fmt.Println("Options:")
	// 	flag.PrintDefaults()
	// }
	flag.Parse()

	if *help {
		fmt.Println("Usage: wayang-server [options]")
		fmt.Println("Options:")
		flag.PrintDefaults()
		return
	}

	if *version {
		fmt.Println("Version: 1.0.0")
		return
	}

	r := mux.NewRouter()
	r.HandleFunc("/iov/websocket/dual", handleConnection) // 使用 mux 路由器
	fmt.Printf("WebSocket server started on :%d\n", *port)
	err := http.ListenAndServe(fmt.Sprintf("0.0.0.0:%d", *port), r)
	if err != nil {
		fmt.Println("Error starting server:", err)
	}
}
