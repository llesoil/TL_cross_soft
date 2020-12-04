#!/bin/sh

numb='1409'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.2 --psy-rd 2.6 --qblur 0.6 --qcomp 0.8 --vbv-init 0.7 --aq-mode 2 --b-adapt 1 --bframes 12 --crf 20 --keyint 280 --lookahead-threads 0 --min-keyint 25 --qp 40 --qpstep 3 --qpmin 4 --qpmax 66 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset superfast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,1.5,1.6,1.2,2.6,0.6,0.8,0.7,2,1,12,20,280,0,25,40,3,4,66,38,4,1000,-1:-1,umh,show,superfast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"