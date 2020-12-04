#!/bin/sh

numb='94'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.1 --psy-rd 4.0 --qblur 0.4 --qcomp 0.7 --vbv-init 0.5 --aq-mode 1 --b-adapt 1 --bframes 12 --crf 30 --keyint 300 --lookahead-threads 2 --min-keyint 20 --qp 0 --qpstep 4 --qpmin 3 --qpmax 67 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset superfast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,0.5,1.3,1.1,4.0,0.4,0.7,0.5,1,1,12,30,300,2,20,0,4,3,67,18,6,2000,1:1,dia,crop,superfast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"