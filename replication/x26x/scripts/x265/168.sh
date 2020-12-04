#!/bin/sh

numb='169'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.4 --psy-rd 1.2 --qblur 0.5 --qcomp 0.6 --vbv-init 0.2 --aq-mode 3 --b-adapt 0 --bframes 2 --crf 10 --keyint 290 --lookahead-threads 3 --min-keyint 24 --qp 50 --qpstep 3 --qpmin 2 --qpmax 63 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset veryslow --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,1.5,1.3,1.4,1.2,0.5,0.6,0.2,3,0,2,10,290,3,24,50,3,2,63,18,6,1000,1:1,dia,show,veryslow,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"