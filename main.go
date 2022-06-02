package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"os/signal"
	"syscall"
)

var (
	p *os.Process
)

func main() {
	sigs := make(chan os.Signal, 1)

	signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)

	// catch sigterm and send it to underlying process
	go func() {
		sig := <-sigs
		log.Println("got signal", sig)
		if p != nil {
			if err := p.Signal(sig); err != nil {
				log.Println("error sending signal:", err)
			}
		}
	}()

	// run the command
	err := run()
	if exiterr, ok := err.(*exec.ExitError); ok {
		if status, ok := exiterr.Sys().(syscall.WaitStatus); ok {
			os.Exit(status.ExitStatus())
		}
	} else {
		fmt.Fprintf(os.Stderr, "%v\n", err)
	}

}

func run() error {
	// run rest-server command
	syncthingCmd := exec.Command(
		"/usr/local/bin/syncthing",
		os.Args[1:]...,
	)

	syncthingCmd.Env = append(syncthingCmd.Env, os.Environ()...)
	syncthingCmd.Stdin = os.Stdin
	syncthingCmd.Stdout = os.Stdout
	syncthingCmd.Stderr = os.Stderr
	err := syncthingCmd.Run()
	if err != nil {
		return err
	}

	// set the underlying process
	p = syncthingCmd.Process
	return nil
}
