#!/bin/sh

numb='1839'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.2 --psy-rd 2.4 --qblur 0.3 --qcomp 0.8 --vbv-init 0.5 --aq-mode 3 --b-adapt 1 --bframes 6 --crf 40 --keyint 200 --lookahead-threads 3 --min-keyint 29 --qp 20 --qpstep 5 --qpmin 2 --qpmax 67 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset veryslow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,0.5,1.6,1.2,2.4,0.3,0.8,0.5,3,1,6,40,200,3,29,20,5,2,67,18,2,2000,-1:-1,dia,show,veryslow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"