CREATE TABLE IF NOT EXISTS AM_API_POLICY (
            UUID VARCHAR(256),
            NAME VARCHAR(512) NOT NULL,
            DISPLAY_NAME VARCHAR(512) NULL DEFAULT NULL,
            DESCRIPTION VARCHAR (1024),
            DEFAULT_QUOTA_TYPE VARCHAR(25) NOT NULL,
            DEFAULT_QUOTA INTEGER NOT NULL,
            DEFAULT_QUOTA_UNIT VARCHAR(10) NULL,
            DEFAULT_UNIT_TIME INTEGER NOT NULL,
            DEFAULT_TIME_UNIT VARCHAR(25) NOT NULL,
            APPLICABLE_LEVEL VARCHAR(25) NOT NULL,
            IS_DEPLOYED BOOLEAN DEFAULT FALSE,
            CREATED_BY VARCHAR(100),
            CREATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
            UPDATED_BY VARCHAR(100),
            LAST_UPDATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
            PRIMARY KEY (UUID),
            UNIQUE (NAME)
);

CREATE TABLE AM_ENDPOINT (
  UUID VARCHAR(255),
  NAME VARCHAR(100),
  ENDPOINT_CONFIGURATION BYTEA,
  TPS INTEGER,
  TYPE VARCHAR(100),
  APPLICABLE_LEVEL VARCHAR(100),
  SECURITY_CONFIGURATION BYTEA,
  GATEWAY_CONFIG BYTEA,
  CREATED_BY VARCHAR(100),
  CREATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  UPDATED_BY VARCHAR(100),
  LAST_UPDATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (UUID));

CREATE SEQUENCE AM_CONDITION_GROUP_seq;

CREATE TABLE IF NOT EXISTS AM_CONDITION_GROUP (
            CONDITION_GROUP_ID INTEGER DEFAULT NEXTVAL ('AM_CONDITION_GROUP_seq'),
            UUID VARCHAR(256),
            QUOTA_TYPE VARCHAR(25),
            QUOTA INTEGER NOT NULL,
            QUOTA_UNIT VARCHAR(10) NULL DEFAULT NULL,
            UNIT_TIME INTEGER NOT NULL,
            TIME_UNIT VARCHAR(25) NOT NULL,
            DESCRIPTION VARCHAR (1024) NULL DEFAULT NULL,
            PRIMARY KEY (CONDITION_GROUP_ID),
            FOREIGN KEY (UUID) REFERENCES AM_API_POLICY(UUID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE SEQUENCE AM_QUERY_PARAMETER_CONDITION_seq;

CREATE TABLE IF NOT EXISTS AM_QUERY_PARAMETER_CONDITION (
            QUERY_PARAMETER_ID INTEGER NOT NULL DEFAULT NEXTVAL ('AM_QUERY_PARAMETER_CONDITION_seq'),
            CONDITION_GROUP_ID INTEGER NOT NULL,
            PARAMETER_NAME VARCHAR(255) DEFAULT NULL,
            PARAMETER_VALUE VARCHAR(255) DEFAULT NULL,
	    	IS_PARAM_MAPPING BOOLEAN DEFAULT true,
            PRIMARY KEY (QUERY_PARAMETER_ID),
            FOREIGN KEY (CONDITION_GROUP_ID) REFERENCES AM_CONDITION_GROUP(CONDITION_GROUP_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE SEQUENCE AM_HEADER_FIELD_CONDITION_seq;

CREATE TABLE IF NOT EXISTS AM_HEADER_FIELD_CONDITION (
            HEADER_FIELD_ID INTEGER NOT NULL DEFAULT NEXTVAL ('AM_HEADER_FIELD_CONDITION_seq'),
            CONDITION_GROUP_ID INTEGER NOT NULL,
            HEADER_FIELD_NAME VARCHAR(255) DEFAULT NULL,
            HEADER_FIELD_VALUE VARCHAR(255) DEFAULT NULL,
	    	IS_HEADER_FIELD_MAPPING BOOLEAN DEFAULT true,
            PRIMARY KEY (HEADER_FIELD_ID),
            FOREIGN KEY (CONDITION_GROUP_ID) REFERENCES AM_CONDITION_GROUP(CONDITION_GROUP_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE SEQUENCE AM_JWT_CLAIM_CONDITION_seq;

CREATE TABLE IF NOT EXISTS AM_JWT_CLAIM_CONDITION (
            JWT_CLAIM_ID INTEGER NOT NULL DEFAULT NEXTVAL ('AM_JWT_CLAIM_CONDITION_seq'),
            CONDITION_GROUP_ID INTEGER NOT NULL,
            CLAIM_URI VARCHAR(512) DEFAULT NULL,
            CLAIM_ATTRIB VARCHAR(1024) DEFAULT NULL,
	        IS_CLAIM_MAPPING BOOLEAN DEFAULT true,
            PRIMARY KEY (JWT_CLAIM_ID),
            FOREIGN KEY (CONDITION_GROUP_ID) REFERENCES AM_CONDITION_GROUP(CONDITION_GROUP_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE SEQUENCE AM_IP_CONDITION_seq;

CREATE TABLE IF NOT EXISTS AM_IP_CONDITION (
  AM_IP_CONDITION_ID INT NOT NULL DEFAULT NEXTVAL ('AM_IP_CONDITION_seq'),
  STARTING_IP VARCHAR(45) NULL,
  ENDING_IP VARCHAR(45) NULL,
  SPECIFIC_IP VARCHAR(45) NULL,
  WITHIN_IP_RANGE BOOLEAN DEFAULT true,
  CONDITION_GROUP_ID INT NULL,
  PRIMARY KEY (AM_IP_CONDITION_ID),
   FOREIGN KEY (CONDITION_GROUP_ID)    REFERENCES AM_CONDITION_GROUP (CONDITION_GROUP_ID)  ON DELETE CASCADE ON UPDATE CASCADE);

CREATE TABLE AM_APPLICATION_POLICY (
  UUID VARCHAR(255),
  NAME VARCHAR(512) NOT NULL,
  DISPLAY_NAME VARCHAR(512) NULL DEFAULT NULL,
  DESCRIPTION VARCHAR(1024) NULL DEFAULT NULL,
  QUOTA_TYPE VARCHAR(25) NOT NULL,
  QUOTA INT NOT NULL,
  QUOTA_UNIT VARCHAR(10) NULL DEFAULT NULL,
  UNIT_TIME INT NOT NULL,
  TIME_UNIT VARCHAR(25) NOT NULL,
  IS_DEPLOYED BOOLEAN DEFAULT FALSE,
  CUSTOM_ATTRIBUTES BYTEA DEFAULT NULL,
  CREATED_BY VARCHAR(100),
  CREATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  UPDATED_BY VARCHAR(100),
  LAST_UPDATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (UUID),
  CONSTRAINT APP_POLICY_NAME UNIQUE (NAME)
  );

CREATE TABLE AM_SUBSCRIPTION_POLICY (
  UUID VARCHAR(255),
  NAME VARCHAR(255),
  DISPLAY_NAME VARCHAR(512),
  DESCRIPTION VARCHAR(1024),
  QUOTA_TYPE VARCHAR(30),
  QUOTA INTEGER,
  QUOTA_UNIT VARCHAR(30),
  UNIT_TIME INTEGER,
  TIME_UNIT VARCHAR(30),
  RATE_LIMIT_COUNT INTEGER,
  RATE_LIMIT_TIME_UNIT VARCHAR(30),
  IS_DEPLOYED BOOLEAN DEFAULT FALSE,
  CUSTOM_ATTRIBUTES BYTEA,
  STOP_ON_QUOTA_REACH BOOL,
  BILLING_PLAN VARCHAR(30),
  CREATED_BY VARCHAR(100),
  CREATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  UPDATED_BY VARCHAR(100),
  LAST_UPDATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (UUID),
  UNIQUE (NAME)
);

CREATE SEQUENCE AM_API_TYPES_seq;

CREATE TABLE AM_API_TYPES (
  TYPE_ID  INTEGER NOT NULL DEFAULT NEXTVAL ('AM_API_TYPES_seq'),
  TYPE_NAME VARCHAR(255),
  PRIMARY KEY (TYPE_ID),
  UNIQUE (TYPE_NAME)
);

CREATE TABLE AM_API (
  UUID VARCHAR(255),
  PROVIDER VARCHAR(255),
  NAME VARCHAR(255),
  CONTEXT VARCHAR(255),
  VERSION VARCHAR(30),
  IS_DEFAULT_VERSION BOOLEAN,
  DESCRIPTION VARCHAR(1024),
  VISIBILITY VARCHAR(30),
  IS_RESPONSE_CACHED BOOLEAN,
  CACHE_TIMEOUT INTEGER,
  TECHNICAL_OWNER VARCHAR(255),
  TECHNICAL_EMAIL VARCHAR(255),
  BUSINESS_OWNER VARCHAR(255),
  BUSINESS_EMAIL VARCHAR(255),
  LIFECYCLE_INSTANCE_ID VARCHAR(255),
  CURRENT_LC_STATUS VARCHAR(255),
  LC_WORKFLOW_STATUS VARCHAR(255),
  CORS_ENABLED BOOLEAN,
  CORS_ALLOW_ORIGINS VARCHAR(512),
  CORS_ALLOW_CREDENTIALS BOOLEAN,
  CORS_ALLOW_HEADERS VARCHAR(512),
  CORS_ALLOW_METHODS VARCHAR(255),
  API_TYPE_ID INTEGER,
  CREATED_BY VARCHAR(100),
  CREATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  LAST_UPDATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  COPIED_FROM_API VARCHAR(255),
  UPDATED_BY VARCHAR(100),
  SECURITY_SCHEME INTEGER,
  PRIMARY KEY (UUID),
  FOREIGN KEY (API_TYPE_ID) REFERENCES AM_API_TYPES(TYPE_ID),
  UNIQUE (PROVIDER,NAME,VERSION,API_TYPE_ID),
  UNIQUE (CONTEXT,VERSION)
);

ALTER TABLE AM_API ADD COLUMN textsearchable_index_col tsvector;

UPDATE AM_API SET textsearchable_index_col = to_tsvector( coalesce(NAME,'') || ' ' || coalesce(CONTEXT,'') || ' ' || coalesce(PROVIDER,'') || ' ' || coalesce(VERSION,'') || ' ' || coalesce(DESCRIPTION,'') || ' ' || coalesce(TECHNICAL_OWNER,'') || ' ' || coalesce(BUSINESS_OWNER,'') || ' ' || coalesce(CURRENT_LC_STATUS,''));

CREATE INDEX API_SEARCH_INDEX ON AM_API USING GIN (textsearchable_index_col);

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON AM_API FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger(textsearchable_index_col, 'pg_catalog.english', NAME, CONTEXT, PROVIDER, VERSION, DESCRIPTION, TECHNICAL_OWNER, BUSINESS_OWNER, CURRENT_LC_STATUS);

CREATE TABLE AM_API_ENDPOINT_MAPPING (
  API_ID VARCHAR(255),
  TYPE VARCHAR(25),
  ENDPOINT_ID VARCHAR(255),
  UNIQUE (API_ID,ENDPOINT_ID,TYPE),
  FOREIGN KEY (API_ID) REFERENCES AM_API(UUID) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (ENDPOINT_ID) REFERENCES AM_ENDPOINT(UUID)
  );

CREATE TABLE AM_API_VISIBLE_ROLES (
  API_ID VARCHAR(255),
  ROLE VARCHAR(255),
  PRIMARY KEY (API_ID, ROLE),
  FOREIGN KEY (API_ID) REFERENCES AM_API(UUID) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE AM_API_TAG_MAPPING (
  API_ID VARCHAR(255),
  TAG_ID VARCHAR(255),
  PRIMARY KEY (API_ID, TAG_ID),
  FOREIGN KEY (API_ID) REFERENCES AM_API(UUID) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE AM_TAGS (
  TAG_ID VARCHAR(255),
  NAME VARCHAR(255),
  COUNT INTEGER,
  PRIMARY KEY (TAG_ID)
);

CREATE TABLE AM_API_SUBS_POLICY_MAPPING (
  API_ID VARCHAR(255),
  SUBSCRIPTION_POLICY_ID VARCHAR(255),
  PRIMARY KEY (API_ID, SUBSCRIPTION_POLICY_ID),
  FOREIGN KEY (API_ID) REFERENCES AM_API(UUID) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (SUBSCRIPTION_POLICY_ID) REFERENCES AM_SUBSCRIPTION_POLICY(UUID) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE AM_API_POLICY_MAPPING (
  API_ID VARCHAR(255),
  API_POLICY_ID VARCHAR(255),
  PRIMARY KEY (API_ID, API_POLICY_ID),
  FOREIGN KEY (API_ID) REFERENCES AM_API(UUID) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (API_POLICY_ID) REFERENCES AM_API_POLICY(UUID) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE AM_API_OPERATION_MAPPING (
  API_ID VARCHAR(255),
  OPERATION_ID VARCHAR(255),
  HTTP_METHOD VARCHAR(30),
  URL_PATTERN VARCHAR(255),
  AUTH_SCHEME VARCHAR(30),
  API_POLICY_ID VARCHAR(255),
  PRIMARY KEY (API_ID,OPERATION_ID),
  FOREIGN KEY (API_ID) REFERENCES AM_API(UUID) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (API_POLICY_ID) REFERENCES AM_API_POLICY(UUID)
);

CREATE TABLE AM_API_RESOURCE_ENDPOINT (
  API_ID VARCHAR(255),
  OPERATION_ID VARCHAR(255),
  TYPE VARCHAR(25),
  ENDPOINT_ID VARCHAR(255),
  UNIQUE (API_ID,ENDPOINT_ID,TYPE,OPERATION_ID),
  FOREIGN KEY (API_ID , OPERATION_ID) REFERENCES AM_API_OPERATION_MAPPING(API_ID , OPERATION_ID) ON DELETE CASCADE,
  FOREIGN KEY (ENDPOINT_ID) REFERENCES AM_ENDPOINT(UUID)
  );

CREATE TABLE AM_APPLICATION (
  UUID VARCHAR(255),
  NAME VARCHAR(255),
  APPLICATION_POLICY_ID VARCHAR(255),
  DESCRIPTION VARCHAR(1024),
  APPLICATION_STATUS VARCHAR(255),
  CREATED_BY VARCHAR(100),
  CREATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  UPDATED_BY VARCHAR(100),
  LAST_UPDATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (UUID),
  UNIQUE (NAME),
  FOREIGN KEY (APPLICATION_POLICY_ID) REFERENCES AM_APPLICATION_POLICY(UUID) ON UPDATE CASCADE
);

CREATE TABLE AM_APP_KEY_MAPPING (
  APPLICATION_ID VARCHAR(255),
  CLIENT_ID VARCHAR(255),
  KEY_TYPE VARCHAR(255),
  PRIMARY KEY (APPLICATION_ID, KEY_TYPE),
  FOREIGN KEY (APPLICATION_ID) REFERENCES AM_APPLICATION(UUID) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE AM_API_TRANSPORTS (
  API_ID VARCHAR(255),
  TRANSPORT VARCHAR(30),
  PRIMARY KEY (API_ID, TRANSPORT),
  FOREIGN KEY (API_ID) REFERENCES AM_API(UUID) ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE SEQUENCE AM_RESOURCE_CATEGORIES_seq;

CREATE TABLE AM_RESOURCE_CATEGORIES (
  RESOURCE_CATEGORY_ID INTEGER DEFAULT NEXTVAL ('AM_RESOURCE_CATEGORIES_seq'),
  RESOURCE_CATEGORY VARCHAR(255),
  PRIMARY KEY (RESOURCE_CATEGORY_ID),
  UNIQUE (RESOURCE_CATEGORY)
);

CREATE TABLE AM_API_RESOURCES (
  UUID VARCHAR(255),
  API_ID VARCHAR(255),
  RESOURCE_CATEGORY_ID INTEGER,
  DATA_TYPE VARCHAR(255),
  RESOURCE_TEXT_VALUE VARCHAR(1024),
  RESOURCE_BINARY_VALUE BYTEA,
  CREATED_BY VARCHAR(100),
  CREATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  UPDATED_BY VARCHAR(100),
  LAST_UPDATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (UUID),
  FOREIGN KEY (API_ID) REFERENCES AM_API(UUID) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (RESOURCE_CATEGORY_ID) REFERENCES AM_RESOURCE_CATEGORIES(RESOURCE_CATEGORY_ID)
);

CREATE TABLE AM_API_DOC_META_DATA (
  UUID VARCHAR(255),
  NAME VARCHAR(255),
  SUMMARY VARCHAR(1024),
  TYPE VARCHAR(255),
  OTHER_TYPE_NAME VARCHAR(255),
  SOURCE_URL VARCHAR(255),
  FILE_NAME VARCHAR(255),
  SOURCE_TYPE VARCHAR(255),
  VISIBILITY VARCHAR(30),
  CREATED_BY VARCHAR(100),
  CREATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  UPDATED_BY VARCHAR(100),
  LAST_UPDATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (UUID),
  FOREIGN KEY (UUID) REFERENCES AM_API_RESOURCES(UUID) ON UPDATE CASCADE ON DELETE CASCADE
 );

CREATE TABLE IF NOT EXISTS AM_SUBSCRIPTION (
  UUID VARCHAR(255),
  TIER_ID VARCHAR(50),
  API_ID VARCHAR(255),
  APPLICATION_ID VARCHAR(255),
  SUB_STATUS VARCHAR(50),
  SUB_TYPE VARCHAR(50),
  CREATED_BY VARCHAR(100),
  CREATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  UPDATED_BY VARCHAR(100),
  LAST_UPDATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  FOREIGN KEY(APPLICATION_ID) REFERENCES AM_APPLICATION(UUID) ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY(API_ID) REFERENCES AM_API(UUID) ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY(TIER_ID) REFERENCES AM_SUBSCRIPTION_POLICY(UUID) ON UPDATE CASCADE ON DELETE RESTRICT,
  PRIMARY KEY (UUID)
);

CREATE TABLE AM_API_GROUP_PERMISSION (
  API_ID VARCHAR(255) NOT NULL DEFAULT '',
  GROUP_ID VARCHAR(255) NOT NULL,
  PERMISSION INTEGER DEFAULT NULL,
  PRIMARY KEY (API_ID,GROUP_ID),
  FOREIGN KEY (API_ID) REFERENCES AM_API(UUID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE AM_APPS_GROUP_PERMISSION (
  APPLICATION_ID VARCHAR(255) NOT NULL DEFAULT '',
  GROUP_ID VARCHAR(11) NOT NULL,
  PERMISSION INTEGER DEFAULT NULL,
  PRIMARY KEY (APPLICATION_ID,GROUP_ID),
  FOREIGN KEY (APPLICATION_ID) REFERENCES AM_APPLICATION (UUID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE AM_DOC_GROUP_PERMISSION (
  DOC_ID VARCHAR(255) NOT NULL DEFAULT '',
  GROUP_ID VARCHAR(11) NOT NULL,
  PERMISSION INTEGER DEFAULT NULL,
  PRIMARY KEY (DOC_ID,GROUP_ID),
  FOREIGN KEY (DOC_ID) REFERENCES AM_API_DOC_META_DATA (UUID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE AM_API_LABEL_MAPPING (
  API_ID VARCHAR(255),
  LABEL_ID VARCHAR(255),
  PRIMARY KEY (API_ID, LABEL_ID),
  FOREIGN KEY (API_ID) REFERENCES AM_API(UUID) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE AM_LABELS (
  LABEL_ID VARCHAR(255),
  NAME VARCHAR(255),
  PRIMARY KEY (LABEL_ID),
  UNIQUE (NAME)
);

CREATE TABLE AM_LABEL_ACCESS_URL_MAPPING (
  LABEL_ID VARCHAR(255),
  ACCESS_URL VARCHAR(255),
  PRIMARY KEY (LABEL_ID, ACCESS_URL),
  FOREIGN KEY (LABEL_ID) REFERENCES AM_LABELS(LABEL_ID) ON DELETE CASCADE
);

CREATE SEQUENCE AM_LAMBDA_FUNCTION_seq;

CREATE TABLE IF NOT EXISTS AM_LAMBDA_FUNCTION (
   FUNCTION_ID INTEGER DEFAULT NEXTVAL ('AM_LAMBDA_FUNCTION_seq'),
   FUNCTION_NAME VARCHAR(255) NOT NULL,
   FUNCTION_URI VARCHAR(255) NOT NULL,
   USER_NAME VARCHAR(255) NOT NULL,
   PRIMARY KEY (FUNCTION_ID),
   UNIQUE (FUNCTION_URI)
);

CREATE TABLE IF NOT EXISTS AM_EVENT_FUNCTION_MAPPING (
   FUNCTION_ID INTEGER,
   EVENT VARCHAR(255),
   PRIMARY KEY (FUNCTION_ID, EVENT),
   FOREIGN KEY (FUNCTION_ID) REFERENCES AM_LAMBDA_FUNCTION(FUNCTION_ID) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE SEQUENCE AM_WORKFLOWS_seq;

CREATE TABLE IF NOT EXISTS AM_WORKFLOWS (
    WF_ID INTEGER NOT NULL DEFAULT NEXTVAL ('AM_WORKFLOWS_seq'),
    WF_REFERENCE VARCHAR(255) NOT NULL,
    WF_TYPE VARCHAR(255) NOT NULL,
    WF_STATUS VARCHAR(255) NOT NULL,
    WF_CREATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
    WF_UPDATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
    WF_STATUS_DESC TEXT,
    WF_ATTRIBUTES TEXT,
    WF_EXTERNAL_REFERENCE VARCHAR(255) NOT NULL,
    PRIMARY KEY (WF_ID)
);

CREATE TABLE AM_API_RATINGS (
  UUID VARCHAR(255) NOT NULL,
  API_ID VARCHAR(255) NOT NULL,
  RATING FLOAT,
  USER_IDENTIFIER VARCHAR(255) NOT NULL,
  CREATED_BY VARCHAR(100),
  CREATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  UPDATED_BY VARCHAR(100),
  LAST_UPDATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  FOREIGN KEY(API_ID) REFERENCES AM_API(UUID) ON UPDATE CASCADE ON DELETE CASCADE,
  PRIMARY KEY (UUID),
  UNIQUE (API_ID,USER_IDENTIFIER)
);

CREATE TABLE AM_API_COMMENTS (
  UUID VARCHAR(255) NOT NULL,
  COMMENT_TEXT TEXT,
  USER_IDENTIFIER VARCHAR(255),
  API_ID VARCHAR(255) NOT NULL,
  CREATED_BY VARCHAR(100),
  CREATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  UPDATED_BY VARCHAR(100),
  LAST_UPDATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
  FOREIGN KEY(API_ID) REFERENCES AM_API(UUID) ON UPDATE CASCADE ON DELETE CASCADE,
  PRIMARY KEY (UUID)
);

CREATE SEQUENCE AM_BLOCK_CONDITIONS_SEQ START WITH 1 INCREMENT BY 1;
CREATE TABLE AM_BLOCK_CONDITIONS (
  CONDITION_ID INTEGER DEFAULT NEXTVAL('AM_BLOCK_CONDITIONS_SEQ'),
  TYPE varchar(45) DEFAULT NULL,
  VALUE varchar(512) DEFAULT NULL,
  ENABLED BOOLEAN DEFAULT TRUE,
  UUID VARCHAR(256),
  PRIMARY KEY (CONDITION_ID),
  UNIQUE (UUID)
);

CREATE SEQUENCE AM_IP_RANGE_CONDITION_SEQ START WITH 1 INCREMENT BY 1;
CREATE TABLE IF NOT EXISTS AM_IP_RANGE_CONDITION (
  AM_IP_RANGE_CONDITION_ID INTEGER DEFAULT NEXTVAL('AM_IP_RANGE_CONDITION_SEQ'),
  STARTING_IP VARCHAR(45) NULL,
  ENDING_IP VARCHAR(45) NULL,
  UUID VARCHAR(254),
  PRIMARY KEY (AM_IP_RANGE_CONDITION_ID),
  FOREIGN KEY (UUID) REFERENCES AM_BLOCK_CONDITIONS (UUID)  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS AM_CUSTOM_POLICY (
            UUID VARCHAR(256),
            NAME VARCHAR(512) NOT NULL,
            KEY_TEMPLATE VARCHAR(512) NOT NULL,
            DESCRIPTION VARCHAR(1024) NULL DEFAULT NULL,
            SIDDHI_QUERY BYTEA DEFAULT NULL,
            IS_DEPLOYED BOOLEAN DEFAULT TRUE,
            PRIMARY KEY (UUID),
            UNIQUE (UUID)
);

CREATE TABLE IF NOT EXISTS AM_THREAT_PROTECTION_POLICIES (
  UUID VARCHAR(255),
  NAME VARCHAR(255) UNIQUE NOT NULL,
  TYPE VARCHAR(64) NOT NULL,
  POLICY BYTEA NOT NULL,
  PRIMARY KEY(UUID)
);

CREATE TABLE IF NOT EXISTS AM_THREAT_PROTECTION_MAPPING (
  API_ID VARCHAR(255),
  POLICY_ID VARCHAR(255),
  FOREIGN KEY (POLICY_ID) REFERENCES AM_THREAT_PROTECTION_POLICIES(UUID) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (API_ID) REFERENCES AM_API(UUID)  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE SEQUENCE AM_SYSTEM_APPS_seq;

CREATE TABLE IF NOT EXISTS AM_SYSTEM_APPS (
            ID INTEGER DEFAULT NEXTVAL ('AM_SYSTEM_APPS_seq'),
            NAME VARCHAR(50) NOT NULL,
            CONSUMER_KEY VARCHAR(512) NOT NULL,
            CREATED_TIME TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6),
            PRIMARY KEY (ID)
);

CREATE TABLE IF NOT EXISTS AM_USER_NAME_MAPPING (
  PSEUDO_NAME VARCHAR(255) NOT NULL,
  USER_DOMAIN_NAME VARCHAR(255),
  USER_IDENTIFIER VARCHAR(255) NOT NULL,
  PRIMARY KEY(PSEUDO_NAME),
  UNIQUE (USER_IDENTIFIER)
);
