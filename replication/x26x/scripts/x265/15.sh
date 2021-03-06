#!/bin/sh

numb='16'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 1.4 --qblur 0.3 --qcomp 0.7 --vbv-init 0.7 --aq-mode 1 --b-adapt 2 --bframes 6 --crf 5 --keyint 300 --lookahead-threads 1 --min-keyint 28 --qp 40 --qpstep 4 --qpmin 4 --qpmax 69 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset slow --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,1.0,1.5,1.0,1.4,0.3,0.7,0.7,1,2,6,5,300,1,28,40,4,4,69,38,2,2000,-1:-1,hex,show,slow,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"