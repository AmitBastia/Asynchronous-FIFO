# Asynchronous-FIFO
An Asynchronous FIFO (First-In-First-Out) is a dual-clock memory structure used to safely transfer data between two independent clock domains operating at different frequencies. It uses separate write and read clocks, along with Gray-coded read/write pointers and multi-flop synchronizers, to prevent metastability and ensure reliable cross-domain communication. Asynchronous FIFOs are widely used in high-speed digital systems for clock domain crossing (CDC), buffering burst data, and interfacing modules running at different clock rates—such as processor-to-peripheral communication, high-speed serial interfaces, networking systems, and SoC interconnects.

# Schematic
![image_alt](https://github.com/AmitBastia/Asynchronous-FIFO/blob/main/Schematic_Async_FIFO.png?raw=true)

# Simulation
![image alt](https://github.com/AmitBastia/Asynchronous-FIFO/blob/main/Simulation_Async_FIFO.png?raw=true)
