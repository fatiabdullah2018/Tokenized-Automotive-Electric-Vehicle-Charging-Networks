# Tokenized Automotive Electric Vehicle Charging Networks

A comprehensive blockchain-based system for managing electric vehicle (EV) charging networks using Clarity smart contracts on the Stacks blockchain.

## Overview

This project implements a decentralized EV charging network that provides:

- **Station Verification**: Validates and manages EV charging stations
- **Charging Coordination**: Coordinates EV charging sessions between users and stations
- **Payment Processing**: Handles secure payments for charging services
- **Grid Integration**: Manages integration with the electrical grid for load balancing
- **Usage Optimization**: Optimizes charging station usage and scheduling

## Architecture

### Smart Contracts

1. **charging-station-verification.clar**
    - Registers and verifies charging stations
    - Manages station status and ownership
    - Tracks station usage statistics

2. **charging-coordination.clar**
    - Handles charging session requests and management
    - Coordinates station availability
    - Manages session lifecycle (request → active → completed)

3. **payment-processing.clar**
    - Processes payments for charging sessions
    - Manages user balances and station earnings
    - Handles payment validation and security

4. **grid-integration.clar**
    - Manages electrical grid integration
    - Handles load balancing and power allocation
    - Monitors grid status and capacity

5. **usage-optimization.clar**
    - Optimizes charging station usage
    - Manages time slot reservations
    - Provides intelligent scheduling recommendations

## Features

### For Station Owners
- Register and verify charging stations
- Monitor station usage and earnings
- Manage station availability and maintenance

### For EV Drivers
- Find and reserve charging stations
- Schedule charging sessions
- Make secure payments
- Track charging history

### For Grid Operators
- Monitor grid load and capacity
- Manage power allocation to stations
- Balance electrical demand

## Getting Started

### Prerequisites
- Stacks blockchain node
- Clarity CLI tools
- Node.js and npm (for testing)

### Installation

1. Clone the repository:
   \`\`\`bash
   git clone <repository-url>
   cd ev-charging-network
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Deploy contracts to Stacks blockchain:
   \`\`\`bash
# Deploy each contract in order
clarinet deploy contracts/charging-station-verification.clar
clarinet deploy contracts/charging-coordination.clar
clarinet deploy contracts/payment-processing.clar
clarinet deploy contracts/grid-integration.clar
clarinet deploy contracts/usage-optimization.clar
\`\`\`

### Testing

Run the test suite:
\`\`\`bash
npm test
\`\`\`

Individual test files:
\`\`\`bash
npm test charging-station-verification.test.js
npm test charging-coordination.test.js
npm test payment-processing.test.js
npm test grid-integration.test.js
npm test usage-optimization.test.js
\`\`\`

## Usage Examples

### Register a Charging Station
\`\`\`clarity
(contract-call? .charging-station-verification register-station "Downtown Station A" u150)
\`\`\`

### Request a Charging Session
\`\`\`clarity
(contract-call? .charging-coordination request-charging-session u1 u50)
\`\`\`

### Add Funds to Account
\`\`\`clarity
(contract-call? .payment-processing add-funds u10000)
\`\`\`

### Reserve Time Slot
\`\`\`clarity
(contract-call? .usage-optimization reserve-time-slot u1 u1200)
\`\`\`

## Contract Interactions

### Station Verification Flow
1. Station owner registers station
2. Admin verifies station
3. Station becomes available for use
4. Usage statistics are tracked

### Charging Session Flow
1. User requests charging session
2. System checks station availability
3. Session is started and tracked
4. Payment is processed
5. Session is completed

### Grid Integration Flow
1. Grid status is monitored
2. Power is allocated to stations
3. Load balancing is maintained
4. Usage is optimized based on grid capacity

## Security Features

- **Access Control**: Role-based permissions for different user types
- **Input Validation**: Comprehensive validation of all inputs
- **Error Handling**: Robust error handling with descriptive error codes
- **Balance Verification**: Secure payment processing with balance checks

## Error Codes

### Station Verification (100-199)
- \`ERR_UNAUTHORIZED (100)\`: Unauthorized access
- \`ERR_STATION_EXISTS (101)\`: Station already exists
- \`ERR_STATION_NOT_FOUND (102)\`: Station not found
- \`ERR_INVALID_STATUS (103)\`: Invalid station status

### Charging Coordination (200-299)
- \`ERR_SESSION_EXISTS (201)\`: Session already exists
- \`ERR_SESSION_NOT_FOUND (202)\`: Session not found
- \`ERR_STATION_UNAVAILABLE (204)\`: Station not available

### Payment Processing (300-399)
- \`ERR_INSUFFICIENT_BALANCE (300)\`: Insufficient balance
- \`ERR_PAYMENT_NOT_FOUND (301)\`: Payment not found
- \`ERR_INVALID_AMOUNT (303)\`: Invalid payment amount

### Grid Integration (400-499)
- \`ERR_INVALID_LOAD (401)\`: Invalid load value
- \`ERR_GRID_OVERLOAD (402)\`: Grid capacity exceeded

### Usage Optimization (500-599)
- \`ERR_INVALID_TIME_SLOT (500)\`: Invalid time slot
- \`ERR_SLOT_OCCUPIED (501)\`: Time slot already occupied

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Create an issue in the GitHub repository
- Contact the development team
- Check the documentation for common solutions

## Roadmap

- [ ] Mobile app integration
- [ ] Advanced analytics dashboard
- [ ] Multi-chain support
- [ ] IoT device integration
- [ ] Machine learning optimization
- [ ] Carbon credit tracking
- [ ] Dynamic pricing algorithms
- [ ] Fleet management features
