#start with base image
FROM golang:1.22.5 as Base

#set the working directory inside the container
WORKDIR /app

#copy the go mod and go.sum files inside the working directiry
COPY go.mod ./

#Download all dependencies
RUN go mod download

#copy the source directory to working directory
COPY . .

#Build the application
RUN go build -o main .

#Reduce the image size using distroless image
FROM gcr.io/distroless/base

# Copy the binary from the previous stage
COPY --from=base /app/main .

# Copy the static files from the previous stage
COPY --from=base /app/static ./static

# Expose the port on which the application will run
EXPOSE 8000

# Command to run the application
CMD [ "./main" ]
