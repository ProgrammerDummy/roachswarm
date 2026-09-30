# roachswarm
Signed A/B OTA update system hosted on STM32L476RG

## Layout

- `docs/` - notes on the message formay, flash layout, and decisions
- `firmware/` - application code, linker scripts, startup code, makefiles
- `gateway/` - rust daemon that talks to the board over serial
- `proto/` - message definitions in rust and C
- `rig/` - scripts for the testing rig
- `server/` - rust service that stores and sends firmware images
- `signer/` - tool that signs a firmware image
- `simulator/` - simulated device to test the server without hardware

