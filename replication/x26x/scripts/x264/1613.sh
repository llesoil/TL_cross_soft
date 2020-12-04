#!/bin/sh

numb='1614'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 0.2 --qblur 0.6 --qcomp 0.9 --vbv-init 0.7 --aq-mode 3 --b-adapt 1 --bframes 6 --crf 40 --keyint 250 --lookahead-threads 0 --min-keyint 23 --qp 20 --qpstep 4 --qpmin 0 --qpmax 68 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset veryslow --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.0,1.1,1.1,0.2,0.6,0.9,0.7,3,1,6,40,250,0,23,20,4,0,68,28,5,2000,-2:-2,umh,crop,veryslow,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"