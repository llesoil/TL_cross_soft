#!/bin/sh

numb='2751'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.2 --psy-rd 1.2 --qblur 0.2 --qcomp 0.8 --vbv-init 0.8 --aq-mode 2 --b-adapt 2 --bframes 12 --crf 40 --keyint 220 --lookahead-threads 3 --min-keyint 26 --qp 40 --qpstep 5 --qpmin 0 --qpmax 62 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset superfast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,2.5,1.4,1.2,1.2,0.2,0.8,0.8,2,2,12,40,220,3,26,40,5,0,62,38,3,1000,1:1,hex,show,superfast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"