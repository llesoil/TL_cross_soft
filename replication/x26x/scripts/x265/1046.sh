#!/bin/sh

numb='1047'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 4.6 --qblur 0.4 --qcomp 0.6 --vbv-init 0.4 --aq-mode 3 --b-adapt 2 --bframes 8 --crf 10 --keyint 280 --lookahead-threads 2 --min-keyint 29 --qp 50 --qpstep 5 --qpmin 4 --qpmax 67 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset veryslow --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,3.0,1.2,1.2,4.6,0.4,0.6,0.4,3,2,8,10,280,2,29,50,5,4,67,48,1,2000,-2:-2,hex,show,veryslow,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"