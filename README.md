# Tea Subscription

## Table of Contents
- [Getting Started](#getting-started)
- [Project Description](#project-description)
- [End Points](#end-points)
- [Contributors](#contributors)

## Getting Started
### Versions
- Ruby: 3.2.2
- Rails: 7.1.3

## Project Description

Tea Subscription is a Rails API for a Tea Subscription Service. This Project exposes three different endpoints. These endpoints include creating new active Tea Subscriptions, canceling Tea Subscriptions, and tracking all Tea Subscriptions both active and cancel.

This app was a solo a built as part of the Back End [Take Home Challenge](https://mod4.turing.edu/projects/take_home/take_home_be), from Turing School of Software and Design.

<details>
  <summary>Setup</summary>
  1. Fork and/or Clone this Repo from GitHub.
  2. In your terminal use `$ git clone <ssh or https path>`.
  3. Change into the cloned directory using `$ cd example`.
  4. Install the gem packages using `$ bundle install`.
  5. Database Migrations can be set up by running: 
  ``` bash 
  $ rails rake db:{drop,create,migrate,seed}
  ```
</details>

<details>
  <summary>Testing</summary>

  Test using the terminal utilizing RSpec:

  ```bash
  $ bundle exec rspec spec/<follow directory path to test specific files>
  ```

  or test the whole suite with `$ bundle exec rspec`

  Test Results as of 8/25/24: 100% test coverage via gem .simplecov
</details>

<details>
  <summary>Database Schema</summary>
  
```
ActiveRecord::Schema[7.1].define(version: 2024_08_20_044257) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "customer_subscriptions", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "subscription_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_customer_subscriptions_on_customer_id"
    t.index ["subscription_id"], name: "index_customer_subscriptions_on_subscription_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.string "address", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "title", null: false
    t.float "price", null: false
    t.integer "frequency", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tea_subscriptions", force: :cascade do |t|
    t.bigint "subscription_id", null: false
    t.bigint "tea_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscription_id"], name: "index_tea_subscriptions_on_subscription_id"
    t.index ["tea_id"], name: "index_tea_subscriptions_on_tea_id"
  end

  create_table "teas", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.float "tempature"
    t.integer "brew_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "customer_subscriptions", "customers"
  add_foreign_key "customer_subscriptions", "subscriptions"
  add_foreign_key "tea_subscriptions", "subscriptions"
  add_foreign_key "tea_subscriptions", "teas"
end
```
</details>

## End Points
### Tea Subscriptions
<details>
<summary> Create a Tea Subscription </summary>

Request:

```http
POST /api/v1/customer_subscriptions
Content-Type: application/json
Accept: application/json
```

Body: 

```json
{
  "subscription_id": "1",
  "customer_id": "1",
  "status": "cancelled"
}
```

Response: `status: 200`

```json
{
  "data": {
    "id": "5",
    "type": "customer_subscription",
    "attributes": {
      "status": "active"
    },
    "relationships": {
      "customer": {
        "data": {
          "id": "1",
          "type": "customer"
        }
      },
      "subscription": {
        "data": {
          "id": "1",
          "type": "subscription"
        }
      }
    }
  }
}
```
</details>

<details>
<summary> Get all Tea Subscriptions </summary>

Request:

```http
GET /customers/:id/customer_subscriptions
Content-Type: application/json
Accept: application/json
```

Response: `status: 200`

```json
{
  "data": [
    {
      "id": "1",
      "type": "customer_subscription",
      "attributes": {
        "status": "active"
      },
      "relationships": {
          "customer": {
            "data": {
              "id": "1",
              "type": "customer"
            }
          },
          "subscription": {
            "data": {
              "id": "1",
              "type": "subscription"
            }
          }
      }
    },
    {
      "id": "2",
      "type": "customer_subscription",
      "attributes": {
        "status": "cancelled"
      },
      "relationships": {
          "customer": {
            "data": {
              "id": "1",
              "type": "customer"
            }
          },
          "subscription": {
            "data": {
              "id": "1",
              "type": "subscription"
            }
          }
      }
    },
    {
      "id": "3",
      "type": "customer_subscription",
      "attributes": {
        "status": "active"
      },
      "relationships": {
          "customer": {
            "data": {
              "id": "1",
              "type": "customer"
            }
          },
        "subscription": {
          "data": {
            "id": "1",
            "type": "subscription"
          }
        }
      }
    },
    {
      "id": "4",
      "type": "customer_subscription",
      "attributes": {
        "status": "cancelled"
      },
      "relationships": {
          "customer": {
            "data": {
              "id": "1",
              "type": "customer"
            }
          },
        "subscription": {
          "data": {
            "id": "1",
            "type": "subscription"
          }
        }
      }
    }
  ]
}
```
</details>

<details>
<summary> Update a Tea Subscription </summary>

Request:

```http
PATCH /api/v1/customer_subscriptions/:id/cancel
Content-Type: application/json
Accept: application/json
```

Body: 

```json
{
  "status": "active"
}
```

Response: `status: 200`

```json
{
  "data": {
    "id": "2",
    "type": "customer_subscription",
    "attributes": {
      "status": "active"
    },
    "relationships": {
        "customer": {
            "data": {
                "id": "1",
                "type": "customer"
            }
        },
        "subscription": {
            "data": {
                "id": "1",
                "type": "subscription"
            }
        }
    }
  }
}
```
</details>

## Contributors

* Lance Butler | [GitHub](https://github.com/LJ9332) | [LinkedIn](https://www.linkedin.com/in/lance-butler-jr/)
