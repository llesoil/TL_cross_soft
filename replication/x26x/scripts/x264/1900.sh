#!/bin/sh

numb='1901'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 1.4 --qblur 0.2 --qcomp 0.9 --vbv-init 0.1 --aq-mode 0 --b-adapt 1 --bframes 4 --crf 30 --keyint 230 --lookahead-threads 1 --min-keyint 25 --qp 20 --qpstep 3 --qpmin 1 --qpmax 69 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset faster --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,3.0,1.5,1.3,1.4,0.2,0.9,0.1,0,1,4,30,230,1,25,20,3,1,69,28,2,2000,-2:-2,dia,crop,faster,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"