#!/bin/sh

numb='2709'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.3 --psy-rd 1.0 --qblur 0.3 --qcomp 0.6 --vbv-init 0.2 --aq-mode 2 --b-adapt 0 --bframes 12 --crf 50 --keyint 210 --lookahead-threads 2 --min-keyint 30 --qp 40 --qpstep 3 --qpmin 2 --qpmax 67 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset veryslow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,2.5,1.3,1.3,1.0,0.3,0.6,0.2,2,0,12,50,210,2,30,40,3,2,67,48,4,1000,1:1,dia,show,veryslow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"