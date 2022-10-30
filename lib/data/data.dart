

import 'package:pmsmbileapp/style/constants.dart';
import 'package:pmsmbileapp/models/analytic_info_model.dart';
import 'package:pmsmbileapp/models/discussions_info_model.dart';
import 'package:pmsmbileapp/models/referal_info_model.dart';

List analyticData = [
  AnalyticInfo(
    title: "Tenants",
    count: 720,
    svgSrc: "assets/icons/Subscribers.svg",
    color: primaryColor,
  ),
  AnalyticInfo(
    title: "Departments",
    count: 820,
    svgSrc: "assets/icons/Post.svg",
    color: purple,
  ),
  AnalyticInfo(
    title: "apartments",
    count: 920,
    svgSrc: "assets/icons/Pages.svg",
    color: orange,
  ),
  AnalyticInfo(
    title: "units",
    count: 920,
    svgSrc: "assets/icons/Comments.svg",
    color: green,
  ),
];

List discussionData = [
  DiscussionInfoModel(
    imageSrc: "assets/images/photo1.jpg",
    name: "Lutfhi Chan",
    date: "Jan 25,2021",
  ),
  DiscussionInfoModel(
    imageSrc: "assets/images/photo2.jpg",
    name: "Devi Carlos",
    date: "Jan 25,2021",
  ),
  DiscussionInfoModel(
    imageSrc: "assets/images/photo3.jpg",
    name: "Danar Comel",
    date: "Jan 25,2021",
  ),
  DiscussionInfoModel(
    imageSrc: "assets/images/photo4.jpg",
    name: "Karin Lumina",
    date: "Jan 25,2021",
  ),
  DiscussionInfoModel(
    imageSrc: "assets/images/photo5.jpg",
    name: "Fandid Deadan",
    date: "Jan 25,2021",
  ),
  DiscussionInfoModel(
    imageSrc: "assets/images/photo1.jpg",
    name: "Lutfhi Chan",
    date: "Jan 25,2021",
  ),
];

List referalData = [
  ReferalInfoModel(
    title: "Facebook",
    count: 234,
    svgSrc: "assets/icons/Facebook.svg",
    color: primaryColor,
  ),
  ReferalInfoModel(
    title: "Twitter",
    count: 234,
    svgSrc: "assets/icons/Twitter.svg",
    color: primaryColor,
  ),
  ReferalInfoModel(
    title: "Linkedin",
    count: 234,
    svgSrc: "assets/icons/Linkedin.svg",
    color: primaryColor,
  ),

  ReferalInfoModel(
    title: "Dribble",
    count: 234,
    svgSrc: "assets/icons/Dribbble.svg",
    color: red,
  ),
];
