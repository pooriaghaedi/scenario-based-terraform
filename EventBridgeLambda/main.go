// Sample Golang Function from AWS documents, replace with your own
package main

import (
	"fmt"
	"strconv"

	"github.com/aws/aws-lambda-go/lambda"
)

type MyEvent struct {
        Name string `json:"What is your name?"`
        Age int     `json:"How old are you?"`
}
 
type MyResponse struct {
        Message string `json:"Answer:"`
}
 
func HandleLambdaEvent(event MyEvent) (MyResponse, error) {
        fmt.Println(event.Name + "is " + strconv.Itoa(event.Age) + "years old!")
        return MyResponse{Message: fmt.Sprintf("%s is %d years old!", event.Name, event.Age)}, nil
}
 
func main() {
        lambda.Start(HandleLambdaEvent)
}
