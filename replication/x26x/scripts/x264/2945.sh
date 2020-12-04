#!/bin/sh

numb='2946'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.2 --psy-rd 3.0 --qblur 0.4 --qcomp 0.7 --vbv-init 0.9 --aq-mode 3 --b-adapt 2 --bframes 2 --crf 15 --keyint 290 --lookahead-threads 4 --min-keyint 25 --qp 20 --qpstep 5 --qpmin 4 --qpmax 62 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset superfast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,3.0,1.3,1.2,3.0,0.4,0.7,0.9,3,2,2,15,290,4,25,20,5,4,62,48,5,2000,-2:-2,hex,show,superfast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"