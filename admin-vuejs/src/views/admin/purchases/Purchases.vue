<template>
  <div class="purchases">
    <h1>Purchases</h1>
    <form @submit.prevent="onSubmit">
      <div class="queryOptions">
        <span>
          <label for="uid">uid</label>
          <input type="text" v-model="form.uid" placeholder="uid" id="uid"
        /></span>
        <span>
          <label for="status">Status</label>
          <select name="status" id="status" v-model="form.status">
            <option value="">Select Status</option>
            <option value="success">Success</option>
            <option value="pending">Pending</option>
            <option value="failure">Failure</option>
          </select>
        </span>
        <span>
          <label for="productList">Product</label>
          <select name="productList" id="productList" v-model="form.productID">
            <option value="">Select Product</option>
            <option value="lucky_box">Lucky Box</option>
            <option value="jewelry_box">Jewelry Box</option>
            <option value="diamond_box">Diamon Box</option>
          </select>
        </span>
        <span>
          <label for="startDate">Date Start</label>
          <input
            type="text"
            v-model="startDate"
            placeholder="Start Date"
            id="startDate"
          />
        </span>
        <span>
          <label for="endDate">Date End</label>
          <input
            type="text"
            v-model="endDate"
            placeholder="End Date"
            id="endDate"
          />
        </span>
      </div>
      <button>
        Search
      </button>
    </form>

    <h3>Display</h3>
    <div class="displayOptions">
      <span>
        <input
          type="checkbox"
          id="photo"
          name="photo"
          v-model="options.photo"
        />
        <label for="photo">Photo</label>
      </span>
      <span>
        <input
          type="checkbox"
          id="phoneNumber"
          name="phoneNumber"
          v-model="options.phoneNumber"
        />
        <label for="phoneNumber">Phone Number</label>
      </span>
      <span>
        <input
          type="checkbox"
          id="title"
          name="title"
          v-model="options.title"
        />
        <label for="title">Title</label>
      </span>
      <span>
        <input
          type="checkbox"
          id="description"
          name="description"
          v-model="options.description"
        />
        <label for="description">Description</label>
      </span>
      <span>
        <input
          type="checkbox"
          id="price"
          name="price"
          v-model="options.price"
        />
        <label for="price">Price</label>
      </span>
      <span>
        <input
          type="checkbox"
          id="purchaseID"
          name="purchaseID"
          v-model="options.purchaseID"
        />
        <label for="purchaseID">Purchase ID</label>
      </span>
      <span>
        <input
          type="checkbox"
          id="purchaseStatus"
          name="purchaseStatus"
          v-model="options.purchaseStatus"
        />
        <label for="purchaseStatus">Purchase Status</label>
      </span>
      <span>
        <input type="checkbox" id="date" name="date" v-model="options.at" />
        <label for="date">Date</label>
      </span>
    </div>

    <h3>Show Payment Summary</h3>
    <div class="payment-summary">
      <div>
        <button @click="showPaymentSummary = !showPaymentSummary">
          Daily Successful Payment
        </button>
        <div class="daily-success-payment" v-show="showPaymentSummary">
          <div class="day" v-for="(day, d) in successPayment" :key="d">
            <div>{{ d }}</div>
            <div class="currency" v-for="(currency, c) in day" :key="c">
              {{ c }}: {{ currency }}
            </div>
          </div>
        </div>
      </div>

      <div>
        <button @click="showProductSummary = !showProductSummary">
          Product Purchased
        </button>
        <div class="daily-product-purchase" v-show="showProductSummary">
          <div class="day" v-for="(day, d) in productPurchase" :key="d">
            <div>{{ d }}</div>
            <div class="product" v-for="(product, p) in day" :key="p">
              {{ p }}: {{ product }}
            </div>
          </div>
        </div>
      </div>

      <div>
        <button @click="showUserSummary = !showUserSummary">
          User Summary
        </button>
        <div class="user-summary" v-show="showUserSummary">
          <div class="user" v-for="(user, uid) in userPurchase" :key="uid">
            <div>{{ user.name }}({{ user.total }})</div>
            <div class="currency" v-for="(cash, c) in user.currency" :key="c">
              {{ c }}: {{ cash }}
            </div>
          </div>
        </div>
      </div>
      <div>Total Summary</div>
      <div class="total-summary">
        <div
          class="currency"
          v-for="(currency, c) in totalSummary.total"
          :key="c"
        >
          {{ c }}: {{ currency }}
        </div>
      </div>
    </div>

    <table class="transaction">
      <tr>
        <th v-if="options.photo">Photo</th>
        <th>id</th>
        <th>uid</th>
        <th>Name</th>
        <th>Email</th>
        <th v-if="options.phoneNumber">Phone</th>
        <th>Product id</th>
        <th v-if="options.title">Title</th>
        <th v-if="options.description">Description</th>
        <th v-if="options.price">Price</th>
        <th v-if="options.purchaseID">Purchase ID</th>
        <!-- <th v-if="options.purchaseStatus">Purchase Status</th> -->
        <th v-if="options.at">Date</th>
      </tr>
      <tr v-for="transaction in transactions" :key="transaction.id">
        <td v-if="options.photo">
          <img
            v-if="transaction.photoURL"
            :src="transaction.photoURL"
            :alt="transaction.photoURL"
          />
        </td>
        <td>{{ transaction?.id }}</td>
        <td>{{ transaction?.uid }}</td>
        <td>{{ transaction?.displayName ?? "No Name" }}</td>
        <td>{{ transaction?.email }}</td>
        <td v-if="options.phoneNumber">{{ transaction?.phoneNumber }}</td>
        <td>{{ transaction?.productDetails?.id }}</td>
        <td v-if="options.title">{{ transaction?.productDetails?.title }}</td>
        <td v-if="options.description">
          {{ transaction?.productDetails?.description }}
        </td>
        <td v-if="options.price">{{ transaction?.productDetails?.price }}</td>
        <td v-if="options.purchaseID">
          {{ transaction?.purchaseDetails?.productID }}
        </td>
        <!-- <td v-if="options.purchaseStatus">
          {{ transaction?.purchaseDetails?.pendingCompletePurchase }}
        </td> -->
        <td v-if="options.at">{{ transaction.atDate }}</td>
      </tr>
    </table>
  </div>
</template>

<script lang="ts">
import { Options, Vue } from "vue-class-component";

import firebase from "firebase/app";
import "firebase/firestore";
import { proxy } from "@/services/functions";

@Options({
  components: {}
})
export default class Purchases extends Vue {
  historyDoc = firebase
    .firestore()
    .collection("purchase")
    .doc("history");

  // errorCol = this.historyDoc.collection("error");
  // pendingCol = this.historyDoc.collection("pending");
  // successCol = this.historyDoc.collection("success");

  transactions: any[] = [];
  successPayment: { [key: string]: { [key: string]: number } } = {};
  productPurchase: { [key: string]: { [key: string]: number } } = {};
  userPurchase: { [key: string]: { [key: string]: any } } = {};

  totalSummary: { [key: string]: { [key: string]: number } } = {
    total: {}
  };

  form = {
    status: "success",
    productID: ""
  };

  showPaymentSummary = false;
  showProductSummary = false;
  showUserSummary = false;

  date143 = new Date();

  d = new Date();
  sd = new Date(this.d.getFullYear(), this.d.getMonth(), this.d.getDate() - 10);
  startDate = `${this.sd.getFullYear()}/${this.sd.getMonth() + 1}/${this.add0(
    this.sd.getDate()
  )}`;
  endDate = `${this.d.getFullYear()}/${this.d.getMonth() +
    1}/${this.d.getDate()}`;

  options = {
    photo: false,
    phoneNumber: false,
    title: false,
    description: false,
    price: false,
    purchaseID: false,
    purchaseStatus: false,
    beginAt: true,
    endAt: false
  };

  created() {
    // console.log("created");
    this.search();
  }

  add0(num: number) {
    if (num >= 10) return num;
    return "0" + num;
  }

  async search() {
    // console.log("getting purchases");
    const data = proxy(this.form);

    const dAt = new Date(this.startDate);
    // console.log(dAt);
    const beginAt = new Date(dAt.getFullYear(), dAt.getMonth(), dAt.getDate());
    const _beginAt = new firebase.firestore.Timestamp(
      Math.round(beginAt.getTime() / 1000),
      0
    );
    const eAt = new Date(this.endDate);
    // console.log(eAt);
    const endAt = new Date(
      eAt.getFullYear(),
      eAt.getMonth(),
      eAt.getDate() + 1
    );
    // console.log(endAt);
    const _endAt = new firebase.firestore.Timestamp(
      Math.round(endAt.getTime() / 1000),
      0
    );

    let q = this.historyDoc
      .collection(data.status)
      .where("at", ">=", _beginAt)
      .where("at", "<=", _endAt);

    if (data.uid) {
      q = q.where("uid", "==", data.uid);
    }
    if (data.productID) {
      q = q.where("productDetails.id", "==", data.productID);
    }
    const got = await q.get();
    this.prepData(got);
  }

  async onSubmit() {
    this.search();
  }

  prepData(doc: any) {
    this.transactions = [];
    this.successPayment = {};
    this.productPurchase = {};
    this.userPurchase = {};
    console.log(this.transactions);
    doc.docs.forEach((d: any) => {
      const data = d.data();
      const bdate = new Date(data.at.seconds * 1000);
      data["atDate"] = data?.at?.seconds ? bdate.toLocaleString() : "";

      data["id"] = d.id;
      const day =
        "" +
        bdate.getUTCFullYear() +
        "-" +
        (bdate.getUTCMonth() + 1) +
        "-" +
        bdate.getUTCDate();
      if (proxy(this.form).status == "success") {
        const currencyCode =
          data.purchaseDetails.skProduct.priceLocale.currencyCode;
        const price = parseInt(data.purchaseDetails.skProduct.price);
        const product = data.productDetails.id;
        const uid = data.uid;
        /// Total Summary
        if (this.totalSummary["total"][currencyCode] == null)
          this.totalSummary["total"][currencyCode] = 0;
        this.totalSummary["total"][currencyCode] += price;

        /// End of Total Summary

        /// Success Payment Summary
        if (this.successPayment[day] == null) this.successPayment[day] = {};

        if (this.successPayment[day][currencyCode] == null)
          this.successPayment[day][currencyCode] = 0;

        this.successPayment[day][currencyCode] += price;
        /// End of Success Payment Summary

        /// Product Purchase Summary
        if (this.productPurchase[day] == null) this.productPurchase[day] = {};

        if (this.productPurchase[day][product] == null)
          this.productPurchase[day][product] = 0;
        this.productPurchase[day][product]++;
        /// End of Purchase Summary

        /// User Purchase
        if (this.userPurchase[uid] == null) {
          this.userPurchase[uid] = {
            total: 0,
            currency: {},
            name: data.displayName
          };
        }
        this.userPurchase[uid]["total"]++;
        if (this.userPurchase[uid]["currency"][currencyCode] == null)
          this.userPurchase[uid]["currency"][currencyCode] = 0;

        this.userPurchase[uid]["currency"][currencyCode] += price;
        /// End of User Purchase
      }

      this.transactions.push(data);
    });

    // console.log(this.successPayment);
    // console.log(this.productPurchase);
  }
}
</script>

<style lang="scss" scoped>
.purchases {
  padding: 1em;
}
form {
  padding-bottom: 1em;
  .queryOptions {
    display: flex;
    padding-bottom: 1em;
    flex-wrap: wrap;
    span {
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 0.25em 1em;
      margin-right: 1.5em;
      cursor: pointer;
      label {
        padding-right: 0.5em;
        cursor: pointer;
      }
    }
  }
  button {
    padding: 0.5em 2em;
  }
}

.displayOptions {
  display: flex;
  flex-wrap: wrap;
  span {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0.25em 1em;
    margin-right: 1.5em;
    cursor: pointer;
    label {
      padding-left: 0.5em;
      cursor: pointer;
    }
  }
}

.payment-summary {
  button {
    margin-bottom: 1em;
  }
  .daily-success-payment,
  .daily-product-purchase {
    padding-bottom: 1em;
  }
}

table {
  width: 100%;
  padding: 1em 0;
  text-align: center;
  border-spacing: 5px;
  white-space: nowrap;
  img {
    width: 50px;
    height: 50px;
  }
}
.transaction {
  margin-bottom: 1.5em;
  .meta {
    display: flex;
  }
}
</style>
