/*
    Keys are organized in groups
    every computer within a group can send messages to every other computer in the group
*/

CREATE TABLE KeyGroup (
    ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Name` VARCHAR(200) NOT NULL,
    GroupKey VARCHAR(200) NOT NULL,
    CanRegisterKeys VARCHAR(200) NOT NULL,
    IsActive TinyINT NOT NULL DEFAULT 1
);

/*
    When activating the communication the MASTER computer uses its
    GroupKey to create several Keys. Those keys identify 
    every computer in the group. 
    
    Messages can be received as an individual or as a group.
*/
CREATE TABLE Keys (
	ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    KeyGroupId INT NOT NULL REFERENCES KeyGroup(ID),
    Key VARCHAR(200) NOT NULL,
	`Name` VARCHAR(200) NOT NULL,
	IsActive tinyint not null default 1
);

/*
    The MASTER sends messages and in return receives 
    answers from the other computers. Those consist of 
    a command and parameters. The parameters are transfered as json.
*/
CREATE TABLE Message (
    ID BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    KeyGroupId INT REFERENCES KeyGroup(ID),
    SenderKeyId INT REFERENCES Keys(ID),
    ReceiverKeyId INT REFERENCES Keys(ID),
    Command VARCHAR(200) NOT NULL DEFAULT '',
    ParametersJson MEDIUMTEXT
);

/*
    When a key is newly created it receives a ProcessingPointer
    with the current max PK of the Message table.

    From there on, every time it receives messages, the pointer
    is increased. (It receives messages and in turn needs to 
    notify the api that the receiving process went ok.)

    This way we:
    1) only send new messages to clients
    2) can regularily delete all messages that are less than
       the lowest LastProcessedMessageId. This way we can keep
       the database as small as possible.
*/
CREATE TABLE ProcessingPointer (
    ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ReceiverKeyId INT NOT NULL REFERENCES Keys(Id),
    LastProcessedMessageId BIGINT Message(Id),
    IsActive TINYINT NOT NULL DEFAULT 1
);


