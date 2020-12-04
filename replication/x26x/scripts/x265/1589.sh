#!/bin/sh

numb='1590'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --intra-refresh --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 3.2 --qblur 0.3 --qcomp 0.7 --vbv-init 0.0 --aq-mode 0 --b-adapt 1 --bframes 14 --crf 25 --keyint 300 --lookahead-threads 2 --min-keyint 20 --qp 20 --qpstep 5 --qpmin 3 --qpmax 64 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset faster --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,--intra-refresh,None,--slow-firstpass,--weightb,3.0,1.6,1.3,3.2,0.3,0.7,0.0,0,1,14,25,300,2,20,20,5,3,64,28,1,2000,-2:-2,hex,show,faster,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"