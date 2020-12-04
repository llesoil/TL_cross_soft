#!/bin/sh

numb='585'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.1 --psy-rd 5.0 --qblur 0.5 --qcomp 0.7 --vbv-init 0.8 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 20 --keyint 280 --lookahead-threads 4 --min-keyint 23 --qp 0 --qpstep 4 --qpmin 3 --qpmax 66 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset veryslow --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,2.5,1.5,1.1,5.0,0.5,0.7,0.8,3,2,0,20,280,4,23,0,4,3,66,28,6,1000,-1:-1,dia,crop,veryslow,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"