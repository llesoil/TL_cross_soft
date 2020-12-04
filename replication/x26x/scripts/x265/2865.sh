#!/bin/sh

numb='2866'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 2.0 --qblur 0.5 --qcomp 0.8 --vbv-init 0.9 --aq-mode 2 --b-adapt 1 --bframes 2 --crf 15 --keyint 230 --lookahead-threads 3 --min-keyint 22 --qp 50 --qpstep 4 --qpmin 0 --qpmax 69 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset faster --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,1.0,1.6,1.3,2.0,0.5,0.8,0.9,2,1,2,15,230,3,22,50,4,0,69,18,2,1000,-2:-2,dia,crop,faster,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"