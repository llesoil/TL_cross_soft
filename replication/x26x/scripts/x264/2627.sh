#!/bin/sh

numb='2628'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.2 --psy-rd 0.4 --qblur 0.2 --qcomp 0.7 --vbv-init 0.9 --aq-mode 0 --b-adapt 2 --bframes 6 --crf 45 --keyint 200 --lookahead-threads 3 --min-keyint 28 --qp 50 --qpstep 4 --qpmin 3 --qpmax 69 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset superfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.5,1.2,1.2,0.4,0.2,0.7,0.9,0,2,6,45,200,3,28,50,4,3,69,38,4,1000,-1:-1,dia,crop,superfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"