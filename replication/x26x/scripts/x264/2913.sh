#!/bin/sh

numb='2914'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.4 --psy-rd 4.4 --qblur 0.5 --qcomp 0.9 --vbv-init 0.3 --aq-mode 1 --b-adapt 0 --bframes 16 --crf 25 --keyint 260 --lookahead-threads 3 --min-keyint 26 --qp 50 --qpstep 3 --qpmin 1 --qpmax 63 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset veryslow --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,1.5,1.6,1.4,4.4,0.5,0.9,0.3,1,0,16,25,260,3,26,50,3,1,63,28,3,1000,1:1,dia,show,veryslow,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"