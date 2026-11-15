USE APP;

DROP TABLE IF EXISTS BOOKING;

DROP TABLE IF EXISTS BOOKING_TRANSITION;

DROP TABLE IF EXISTS BOOKING_LOCK;

DROP TABLE IF EXISTS BOOKING_PARTITION;

-- 1. Booking
CREATE TABLE BOOKING (
    eid BIGINT AUTO_INCREMENT PRIMARY KEY,
    account_id VARCHAR(14) NOT NULL,
    transition_eid BIGINT NOT NULL COMMENT 'Ref: BOOKING_TRANSITION.eid',
    UNIQUE INDEX idx_acc_tx (account_id, transition_eid),
    UNIQUE INDEX idx_tx_acc (transition_eid, account_id)
) ENGINE = InnoDB;

-- 2. Transition history
CREATE TABLE BOOKING_TRANSITION (
    eid BIGINT AUTO_INCREMENT PRIMARY KEY,
    `date` DATE NOT NULL,
    `state` VARCHAR(20) NOT NULL COMMENT 'Const values: PENDING, PROCESSED, PROCESSING',
    INDEX idx_bt_date_eid (`date`, state)
) ENGINE = InnoDB;

-- 3. Optional 1:1 lock
CREATE TABLE BOOKING_LOCK (
    eid BIGINT AUTO_INCREMENT PRIMARY KEY,
    account_id VARCHAR(14) NOT NULL,
    `lock` BOOLEAN NOT NULL,
    UNIQUE INDEX uq_idx_account_id (account_id, `lock`)
) ENGINE = InnoDB;

-- 4. Booking partition
CREATE TABLE BOOKING_PARTITION (
    eid BIGINT AUTO_INCREMENT PRIMARY KEY,
    `type` VARCHAR(14) NOT NULL COMMENT 'Const values: KAFKA, QUEUE',
    account_id VARCHAR(14) NOT NULL,
    `partition` INT NOT NULL,
    INDEX idx_partition_account (`partition`, type, account_id)
) ENGINE = InnoDB;