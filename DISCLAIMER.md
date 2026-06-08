# ⚠️ DISCLAIMER — READ BEFORE USE

> **THIS IS OPEN-SOURCE, DECENTRALIZED, EXPERIMENTAL SOFTWARE.**
>
> **IT IS PROVIDED "AS-IS" AND "AS-AVAILABLE" WITH ABSOLUTELY NO WARRANTY
> AND NO LIABILITY OF ANY KIND.**
>
> **BY CLONING, BUILDING, RUNNING, DEPLOYING, MODIFYING, INTERACTING WITH,
> OR RELYING ON ANY PART OF THIS REPOSITORY — INCLUDING SCRIPTS,
> CONFIGURATION FILES, DOCKER IMAGES, SMART-CONTRACT ADDRESSES, RPC
> ENDPOINTS, OR DOCUMENTATION — YOU ACKNOWLEDGE AND ACCEPT ALL OF THE RISKS
> DESCRIBED BELOW AND ASSUME FULL AND SOLE RESPONSIBILITY FOR ANY LOSS,
> DAMAGE, OR HARM THAT RESULTS.**

---

## 1. No Warranty

**THE SOFTWARE AND ANY ASSOCIATED CONFIGURATION, DOCUMENTATION, AND SCRIPTS
ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR
A PARTICULAR PURPOSE, TITLE, NON-INFRINGEMENT, ACCURACY, COMPLETENESS,
RELIABILITY, AVAILABILITY, OR UPTIME.**

**NO REPRESENTATION IS MADE THAT THE SOFTWARE IS FREE FROM BUGS, DEFECTS,
VULNERABILITIES, OR MALICIOUS CODE, OR THAT IT WILL FUNCTION CORRECTLY
UNDER ANY SPECIFIC SET OF CIRCUMSTANCES.**

## 2. No Liability

**IN NO EVENT AND UNDER NO LEGAL THEORY (WHETHER IN CONTRACT, TORT,
NEGLIGENCE, STRICT LIABILITY, OR OTHERWISE) SHALL THE AUTHORS,
CONTRIBUTORS, MAINTAINERS, OR ANY PARTY ASSOCIATED WITH THIS REPOSITORY BE
LIABLE FOR:**

- **ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, CONSEQUENTIAL,
  OR PUNITIVE DAMAGES;**
- **LOSS OF FUNDS, TOKENS, ASSETS, PROFITS, REVENUE, BUSINESS, DATA,
  GOODWILL, OR OPPORTUNITY;**
- **COSTS OF PROCUREMENT OF SUBSTITUTE SERVICES;**
- **ANY CLAIMS BY THIRD PARTIES INCLUDING YOUR OWN USERS;**

**ARISING OUT OF OR IN CONNECTION WITH THE USE OF, INABILITY TO USE, OR
INTERACTION WITH THIS SOFTWARE, THE BRIDGE, THE RELATED CONTRACTS, OR ANY
SERVICE BUILT ON TOP OF IT, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
DAMAGES.**

## 3. Decentralized Software — No Operator Relationship

This repository describes a **permissionless, decentralized protocol built on
public blockchains**. There is no central operator, provider, custodian,
intermediary, fiduciary, or service in a traditional sense.

- **There is no central entity that controls the bridge, holds user funds,
  or can reverse transactions.**
- **Running a validator or relayer from this repository makes YOU an
  independent operator.** You are not an employee, agent, partner, or
  contractor of the authors.
- **No party can recover funds that are lost, misdirected, sent to the
  wrong chain, bridged to a wrong address, or stolen.**
- **Transactions on blockchains are final and irreversible by design.**
  Mistakes cannot be undone.

## 4. Risks You Explicitly Accept

The following is a **non-exhaustive** list of risks. There may be others
not described here. **You are responsible for your own due diligence.**

### 4.1 Smart-contract risk

- **The bridge contracts may contain bugs, logic errors, or
  vulnerabilities that result in loss or theft of all assets locked in
  them.**
- **The contracts have not been audited by a formal third-party security
  firm** unless explicitly stated otherwise in this repository.
- **Upgrades, proxy admin changes, or ISM reconfigurations may alter the
  behavior of the bridge in ways that affect existing users and locked
  collateral.**
- **Exploits on Hyperlane core contracts, their dependencies, or
  underlying chains may compromise the bridge.**

### 4.2 Validator and relayer risk

- **Validators may behave maliciously, sign incorrect checkpoints, have
  their keys compromised, collude, or go offline.** The ISM threshold
  configuration mitigates but does not eliminate this risk.
- **The current ISM threshold on this route is low (1 validator per
  direction).** A single compromised validator could potentially forge
  messages. You are relying on the integrity of that validator.
- **Relayers may be unreliable, censor messages, fail to deliver, submit
  transactions with incorrect gas, or be the target of attacks.** Messages
  can be stuck or lost.
- **The relayer wallet is funded by whoever operates the relayer.** If it
  runs out of gas, deliveries stop. There is no guarantee of uptime.

### 4.3 Bridge design risk

- **The wL1 token is a wrapped representation. 1 wL1 on Base is only
  worth 1 L1 so long as the collateral on GenesisL1 remains fully backed
  and the bridge functions correctly.** In a failure scenario, wL1 may
  trade at a significant discount or become worthless.
- **An IGP (Interchain Gas Paymaster) is not currently deployed on
  GenesisL1.** The relayer currently subsidizes destination gas. If the
  relayer stops operating, messages will not be delivered.
- **Cross-chain message ordering, finality assumptions, and reorgs on
  either chain may cause unexpected behavior.**

### 4.4 Blockchain and infrastructure risk

- **The underlying blockchains (GenesisL1, Base, Ethereum) may fork, halt,
  become congested, reorganize, or cease to exist.**
- **RPC endpoints may return stale, incorrect, or malicious data. They
  may be rate-limited, throttled, offline, or censor requests.**
- **GenesisL1's `eth_estimateGas` is known to return incorrect results.**
  Tools that do not account for this may fail, or worse, submit
  transactions with incorrect gas pricing. See
  [docs/troubleshooting.md](docs/troubleshooting.md).
- **Load-balanced RPC setups (e.g. HAProxy) can silently serve stale
  state from slow backends, which causes validators and relayers to
  operate on incorrect data.**

### 4.5 Key-management and operational risk

- **You are solely responsible for the private keys you generate,
  import, and use.** If you lose a key, you lose the associated funds.
  If a key is compromised, any assets it controls can be stolen.
- **Re-using keys across validator, relayer, and user wallets increases
  blast radius in the event of compromise.**
- **Running infrastructure on compromised, poorly configured, or
  unpatched systems exposes your keys and funds to theft.**
- **Exposing RPC endpoints, signature storage buckets, or other
  operational endpoints without appropriate authentication may allow
  third parties to abuse or attack your infrastructure.**

### 4.6 Regulatory, legal, and tax risk

- **The legal and regulatory status of bridging, operating validator or
  relayer infrastructure, issuing or trading wrapped tokens, and
  providing liquidity varies by jurisdiction, is evolving, and may
  require licenses, registration, reporting, or outright prohibit these
  activities where you are located.**
- **The authors and contributors make no representation that the software
  or its use complies with any law, regulation, or rule in any
  jurisdiction.**
- **You are solely responsible for determining the legality of your
  activities and for all tax liabilities arising from them.**

### 4.7 Market, economic, and adversarial risk

- **wL1 and L1 are volatile assets and may lose all of their market
  value.**
- **Liquidity, including that provided on Base DEXes, may be shallow,
  withdrawn, manipulated, or frontrun.**
- **MEV, sandwich attacks, liquidation cascades, oracle manipulation,
  and other adversarial patterns on public blockchains may result in
  losses.**
- **The bridge may be targeted by exploits, governance attacks, social
  engineering, or denial-of-service campaigns.**

### 4.8 Third-party dependencies

- **This repository references third-party software, Docker images,
  RPC endpoints, block explorers, and front-end components that are
  controlled by parties unrelated to this repository.** Their behavior,
  availability, and integrity are outside the control of the authors.
- **Any third-party services (including but not limited to wallet
  extensions, RPC providers, chain explorers, indexers, and monitoring
  tools) may change their terms, pricing, or behavior at any time and
  without notice.**

## 5. No Investment, Legal, Tax, or Financial Advice

Nothing in this repository constitutes investment advice, legal advice,
accounting advice, tax advice, financial advice, or a recommendation to
buy, sell, hold, or interact with any asset. Discussions of economic design,
liquidity bootstrapping, or token mechanics are technical descriptions of
how the software functions — **not** suggestions that you should use them
or take any action.

**Consult qualified professionals before making financial decisions.**

## 6. No Solicitation

This repository is a description of publicly available software. It is not
an offer, solicitation, or invitation to:

- Purchase, sell, or subscribe to any security or financial instrument;
- Provide liquidity to any pool;
- Participate in any governance mechanism;
- Enter into any contract with the authors or any affiliated party.

## 7. Forward-Looking Statements

Documentation may describe planned features, future configurations, or
roadmap items. **These are not promises or commitments.** They may be
delayed, changed, or abandoned at any time without notice. Do not make
decisions based on them.

## 8. Privacy and Data

The software in this repository does not collect personal information.
However, **all interaction with public blockchains is pseudonymous but not
anonymous.** Transactions, addresses, and balances are permanently and
publicly visible. Running validator or relayer infrastructure may expose
your IP address, server hostname, or identifying metadata to the public
internet.

## 9. Modifications and Forks

You may modify, fork, or redistribute this software under the terms of the
[MIT License](LICENSE). **Modified versions are the sole responsibility of
whoever distributes them.** The original authors have no control over, and
no responsibility for, forked or modified versions.

## 10. No Obligation to Maintain

**The authors and contributors have no obligation to maintain, update,
patch, support, or respond to issues or pull requests.** Security
vulnerabilities may not be fixed. The project may be abandoned at any time.

---

## Acceptance

**BY USING ANY PART OF THIS REPOSITORY, YOU AGREE THAT:**

1. **YOU HAVE READ, UNDERSTOOD, AND ACCEPT THIS ENTIRE DISCLAIMER.**
2. **YOU ACCEPT ALL RISKS DESCRIBED AND UNDESCRIBED.**
3. **YOU WILL NOT HOLD THE AUTHORS OR CONTRIBUTORS LIABLE FOR ANY LOSS OR
   DAMAGE.**
4. **YOU ARE RESPONSIBLE FOR YOUR OWN COMPLIANCE WITH ALL APPLICABLE LAWS.**
5. **IF YOU DO NOT AGREE WITH ANY PART OF THIS DISCLAIMER, YOU MUST NOT
   USE THIS SOFTWARE.**

---

*This disclaimer is effective as of the date you access this repository and
applies to all past and future interactions with it and any contracts or
services it describes.*
