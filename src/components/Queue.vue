<template>
    <h1>Queue</h1>

    <ul v-if="!loading && data && data.length">
        <!-- TODO -->
    </ul>

    <p v-if="loading">loading...</p>
    <p v-if="error">
        <!-- TODO -->
        error loading queue {{ error.message }}
    </p>
</template>

<script>
import { onMounted, ref } from "vue";
import { defineComponent } from '@vue/composition-api'

export default defineComponent({
    name: "Queue",
    props: {
    },
    setup() {
        const data = ref(null);
        const loading = ref(true);
        const error = ref(null);
        
        function fetchData() {
            loading.value = true;

            return fetch('https://api.timhatdiehandandermaus.consulting/queue', {
                method: 'get',
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then(res => {
                if (!res.ok) {
                    const error = new Error(res.statusText);
                    error.json = res.json();
                    throw error;
                }

                return res.json();
            }).then(json => {
                data.value = json.data;
            }).catch(err => {
                error.value = err;
                if (err.json) {
                    return err.json.then(json => {
                        error.value.message = json.message;
                    });
                }
            })
            .then(() => {
                loading.value = false;
            })
        }

        onMounted(() => {
            fetchData();
        })

        return {
            data,
            loading,
            error
        };
    },
})
</script>
