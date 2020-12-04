#!/bin/sh

numb='659'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.2 --psy-rd 0.2 --qblur 0.5 --qcomp 0.6 --vbv-init 0.2 --aq-mode 1 --b-adapt 2 --bframes 16 --crf 20 --keyint 210 --lookahead-threads 0 --min-keyint 21 --qp 30 --qpstep 4 --qpmin 2 --qpmax 65 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset superfast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,0.5,1.2,1.2,0.2,0.5,0.6,0.2,1,2,16,20,210,0,21,30,4,2,65,28,5,2000,1:1,hex,show,superfast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"