#!/usr/bin/env python 

import datetime
from utils.munin.base import MuninGraph
from django.contrib.auth.models import User
from apps.profile.models import Profile

graph_config = {
    'graph_category' : 'NewsBlur',
    'graph_title' : 'NewsBlur Users',
    'graph_vlabel' : 'users',
    'all.label': 'all',
    'monthly.label': 'monthly',
    'daily.label': 'daily',
}

last_month = datetime.datetime.now() - datetime.timedelta(days=30)
last_day = datetime.datetime.now() - datetime.timedelta(minutes=60*24)

metrics = {
    'all': User.objects.count(),
    'monthly': Profile.objects.filter(last_seen_on__gte=last_month).count(),
    'daily': Profile.objects.filter(last_seen_on__gte=last_day).count(),
}

if __name__ == '__main__':
    MuninGraph(graph_config, metrics).run()
