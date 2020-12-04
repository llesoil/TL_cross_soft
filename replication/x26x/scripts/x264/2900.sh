#!/bin/sh

numb='2901'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.4 --psy-rd 0.4 --qblur 0.6 --qcomp 0.8 --vbv-init 0.4 --aq-mode 3 --b-adapt 1 --bframes 16 --crf 15 --keyint 230 --lookahead-threads 4 --min-keyint 25 --qp 20 --qpstep 3 --qpmin 0 --qpmax 62 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset faster --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,1.5,1.1,1.4,0.4,0.6,0.8,0.4,3,1,16,15,230,4,25,20,3,0,62,18,3,2000,-1:-1,dia,show,faster,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"