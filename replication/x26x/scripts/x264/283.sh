#!/bin/sh

numb='284'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 1.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.3 --aq-mode 1 --b-adapt 0 --bframes 16 --crf 35 --keyint 280 --lookahead-threads 4 --min-keyint 25 --qp 0 --qpstep 5 --qpmin 2 --qpmax 69 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset faster --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,1.0,1.5,1.3,1.8,0.4,0.9,0.3,1,0,16,35,280,4,25,0,5,2,69,28,6,2000,-1:-1,hex,crop,faster,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"