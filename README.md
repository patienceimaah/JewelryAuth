# JewelryAuth - Handcrafted Jewelry Authentication Platform

A blockchain-based handcrafted jewelry authentication and artisan verification system built on Stacks, ensuring transparency and authenticity in artisan jewelry markets from creation to collection.

## Overview

JewelryAuth enables jewelry artisans to register their handcrafted pieces with detailed crafting information while allowing certified appraisers to verify authenticity, creating trust and transparency in the artisan jewelry market.

## Features

- Jewelry piece registration with type and crafting details
- Crafting techniques and creation date tracking
- Authenticity verification by authorized appraisers
- Artisan collection management and piece tracking
- Comprehensive input validation and security measures

## Smart Contract Functions

### Public Functions
- `register-jewelry-appraiser`: Register authorized jewelry appraisers
- `register-jewelry-piece`: Register new jewelry pieces with crafting data
- `verify-jewelry-authenticity`: Verify authenticity by authorized appraisers

### Read-Only Functions
- `get-jewelry-piece`: Retrieve jewelry piece information
- `get-artisan-collection`: Get artisan's jewelry piece collection
- `is-jewelry-appraiser`: Check jewelry appraiser authorization status

## Usage

Deploy the contract with a contract curator account. Register jewelry appraisers, then artisans can register their jewelry pieces and appraisers can verify authenticity.

## Security

- Contract curator access control for appraiser registration
- Comprehensive input validation for all jewelry piece parameters
- Principal validation to prevent unauthorized access
- Collection capacity limits for system performance