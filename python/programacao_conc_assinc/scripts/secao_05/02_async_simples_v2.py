from asyncio import run, sleep


async def diz_oi():
    print('Oi...')

    await sleep(1)

    print('hahaha...')


if __name__ == '__main__':
    run(diz_oi())
