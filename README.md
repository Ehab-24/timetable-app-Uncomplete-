# TIME TABLE APP

This is a fully functional (currently in progress) mobile application that makes it easy and fun to work with time schedules.

## Description

One of my close friends suggested the idea of creating an app that would make it easy for him to manage his busy schefule, and so I started this project. You can create multiple time tables and specify time slots separately for days of week. You can add reminders for special occassions, events or meetups and can easily modify, and create or delete items in your schedule.

## User Interface

Perhaps the most indulging part of this project is the breathtaking user interface. The design took me quite a while to come up with, however implementing it in flutter was as easy as it gets. The UI also offers neat staggered animations for page transitions and two themes: **Light mode** and **Dark mode**.

<p float="left">
    <img src="https://user-images.githubusercontent.com/109919400/209813127-a531dad4-3735-499c-a84b-31aa8872c70b.jpg" width=:"230" height="460">
    <img src="https://user-images.githubusercontent.com/109919400/209812100-4ba21d6a-39a2-4d43-bea5-0d5e15aada8b.jpg" width=:"230" height="460">
    <img src="https://user-images.githubusercontent.com/109919400/209812111-8c57943e-e15f-4fbd-b5f2-17c1878df469.jpg" width=:"230" height="460">
    <img src="https://user-images.githubusercontent.com/109919400/209812162-17274d72-2d42-4333-8271-125d594f5cc2.jpg" width=:"230" height="460">
</p>

## State Management

For this project, I used the change notifier provider as a state management solution as it is easy to implement and offers a high degree of control while also keeping the app performant.

## Persistence

I made use of the famous **SQFLite** package to store time tables, time slots and reminders in separate SQL tables. While for user preferences, sucha as, username, theme preference etc, I used **shared preferences**.
