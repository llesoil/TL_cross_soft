#!/bin/sh

numb='1923'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --intra-refresh --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.0 --psy-rd 2.2 --qblur 0.2 --qcomp 0.9 --vbv-init 0.5 --aq-mode 0 --b-adapt 1 --bframes 14 --crf 30 --keyint 300 --lookahead-threads 4 --min-keyint 29 --qp 30 --qpstep 5 --qpmin 1 --qpmax 69 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset superfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,--intra-refresh,None,--slow-firstpass,--weightb,0.0,1.1,1.0,2.2,0.2,0.9,0.5,0,1,14,30,300,4,29,30,5,1,69,28,1,2000,1:1,hex,show,superfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"