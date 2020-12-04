#!/bin/sh

numb='1430'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.1 --psy-rd 4.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.4 --aq-mode 1 --b-adapt 2 --bframes 2 --crf 25 --keyint 210 --lookahead-threads 0 --min-keyint 25 --qp 10 --qpstep 3 --qpmin 1 --qpmax 61 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset fast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,1.5,1.3,1.1,4.8,0.4,0.6,0.4,1,2,2,25,210,0,25,10,3,1,61,38,5,1000,-2:-2,hex,show,fast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"