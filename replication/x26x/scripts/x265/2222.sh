#!/bin/sh

numb='2223'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 2.6 --qblur 0.5 --qcomp 0.8 --vbv-init 0.4 --aq-mode 1 --b-adapt 1 --bframes 10 --crf 25 --keyint 240 --lookahead-threads 3 --min-keyint 25 --qp 50 --qpstep 3 --qpmin 1 --qpmax 60 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset placebo --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,3.0,1.5,1.4,2.6,0.5,0.8,0.4,1,1,10,25,240,3,25,50,3,1,60,38,4,2000,1:1,hex,crop,placebo,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"