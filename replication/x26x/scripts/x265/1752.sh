#!/bin/sh

numb='1753'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.4 --psy-rd 3.4 --qblur 0.3 --qcomp 0.9 --vbv-init 0.0 --aq-mode 0 --b-adapt 2 --bframes 8 --crf 25 --keyint 280 --lookahead-threads 4 --min-keyint 22 --qp 20 --qpstep 3 --qpmin 1 --qpmax 68 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset veryslow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,0.5,1.0,1.4,3.4,0.3,0.9,0.0,0,2,8,25,280,4,22,20,3,1,68,38,2,1000,-2:-2,hex,show,veryslow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"