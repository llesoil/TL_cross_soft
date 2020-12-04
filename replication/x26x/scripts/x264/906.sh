#!/bin/sh

numb='907'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.0 --psy-rd 4.4 --qblur 0.6 --qcomp 0.7 --vbv-init 0.3 --aq-mode 2 --b-adapt 1 --bframes 10 --crf 50 --keyint 200 --lookahead-threads 0 --min-keyint 24 --qp 30 --qpstep 4 --qpmin 4 --qpmax 61 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset medium --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,0.5,1.1,1.0,4.4,0.6,0.7,0.3,2,1,10,50,200,0,24,30,4,4,61,18,4,2000,-1:-1,dia,show,medium,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"